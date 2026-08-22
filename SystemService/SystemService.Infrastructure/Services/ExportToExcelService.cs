using ClosedXML.Excel;
using SystemService.Application.Services;
using SystemService.Infrastructure.Common;

namespace SystemService.Infrastructure.Services {
	public class ExportToExcelService : IExportToExcelService {
		public async Task<byte []> ExportToExcel<T>(
			IEnumerable<T> data,
			Dictionary<string, Func<T, object>> columnMappings,
			bool isIncludeSerialNumber,
			string? fileName,
			string? note,
			string? reportTitle = null
		) {
			using var workbook = new XLWorkbook();
			var sheetName = typeof(T).Name + "Export";
			if (sheetName.Length > 31) {
				sheetName = fileName ?? "Sheet1";
				if (sheetName.Length > 31) sheetName = sheetName.Substring(0, 31); // Tránh lỗi vượt quá 31 kí tự của Excel
			}
			var worksheet = workbook.Worksheets.Add(sheetName);

			FillSheetData(worksheet, data, columnMappings, isIncludeSerialNumber, note, reportTitle);

			using var stream = new MemoryStream();
			workbook.SaveAs(stream);
			return await Task.FromResult(stream.ToArray());
		}


		// HÀM HELPER: logic vẽ Excel
		private void FillSheetData<T>(
			IXLWorksheet worksheet, IEnumerable<T> data, Dictionary<string, Func<T, object>> columnMappings,
			bool isIncludeSerialNumber, string? note, string? reportTitle) {
			int currentRow = 1;
			int startCol = 1;
			int totalColumns = columnMappings.Count + (isIncludeSerialNumber ? 1 : 0);
			int noteColIndex = -1;

			// IN TIÊU ĐỀ
			if (!string.IsNullOrWhiteSpace(reportTitle)) {
				var titleCell = worksheet.Cell(currentRow, startCol);
				titleCell.Value = reportTitle.ToUpper();
				titleCell.Style.Font.Bold = true;
				titleCell.Style.Font.FontSize = 14;
				titleCell.Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
				titleCell.Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;
				worksheet.Range(currentRow, startCol, currentRow, totalColumns > 3 ? totalColumns : 5).Merge();
				currentRow += 2;
			}

			// IN HEADER TABLE
			int col = startCol;
			if (isIncludeSerialNumber) worksheet.Cell(currentRow, col++).Value = "STT";

			foreach (var header in columnMappings.Keys) {
				worksheet.Cell(currentRow, col++).Value = header;
			}

			if (!string.IsNullOrWhiteSpace(note)) {
				noteColIndex = col;
				worksheet.Cell(currentRow, col++).Value = note;
				totalColumns++;
			}

			var headerRange = worksheet.Range(currentRow, startCol, currentRow, startCol + totalColumns - 1);
			headerRange.Style.Font.Bold = true;
			headerRange.Style.Font.FontColor = XLColor.White;
			headerRange.Style.Fill.BackgroundColor = XLColor.FromArgb(33, 115, 70);
			headerRange.Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
			headerRange.Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;
			headerRange.Style.Border.OutsideBorder = XLBorderStyleValues.Thin;
			headerRange.Style.Border.InsideBorder = XLBorderStyleValues.Thin;
			headerRange.Style.Alignment.WrapText = true;

			currentRow++;

			// IN DATA ROWS
			int serial = 1;
			foreach (var item in data) {
				col = startCol;
				if (isIncludeSerialNumber) worksheet.Cell(currentRow, col++).Value = serial++;

				foreach (var selector in columnMappings.Values) {
					var value = selector(item);
					ExcelUtils.NormalizeExcelValue(worksheet.Cell(currentRow, col), value);
					col++;
				}

				worksheet.Range(currentRow, startCol, currentRow, startCol + totalColumns - 1).Style.Border.OutsideBorder = XLBorderStyleValues.Thin;
				worksheet.Range(currentRow, startCol, currentRow, startCol + totalColumns - 1).Style.Border.InsideBorder = XLBorderStyleValues.Thin;
				currentRow++;
			}


			worksheet.Columns().AdjustToContents();
		}

		// EXPORT CÓ PHÂN CẤP CHA-CON (Hierarchical Export)
		public async Task<byte []> ExportToExcelHierarchy<T>(
			IEnumerable<T> treeData,
			Func<T, IEnumerable<T>?> childrenSelector,
			Dictionary<string, Func<T, int, object>> columnMappings,
			bool isIncludeSerialNumber,
			string? fileName,
			string? note,
			string? reportTitle = null) {

			using var workbook = new XLWorkbook();
			var sheetName = typeof(T).Name + "Export";
			if (sheetName.Length > 31) {
				sheetName = fileName ?? "Sheet1";
				if (sheetName.Length > 31) sheetName = sheetName.Substring(0, 31);
			}
			var worksheet = workbook.Worksheets.Add(sheetName);

			FillSheetDataHierarchy(worksheet, treeData, childrenSelector, columnMappings, isIncludeSerialNumber, note, reportTitle);

			using var stream = new MemoryStream();
			workbook.SaveAs(stream);
			return await Task.FromResult(stream.ToArray());
		}

		private void FillSheetDataHierarchy<T>(
			IXLWorksheet worksheet,
			IEnumerable<T> treeData,
			Func<T, IEnumerable<T>?> childrenSelector,
			Dictionary<string, Func<T, int, object>> columnMappings,
			bool isIncludeSerialNumber,
			string? note,
			string? reportTitle) {

			int currentRow = 1;
			int startCol = 1;
			int totalColumns = columnMappings.Count + (isIncludeSerialNumber ? 1 : 0);

			// Tiêu đề
			if (!string.IsNullOrWhiteSpace(reportTitle)) {
				var titleCell = worksheet.Cell(currentRow, startCol);
				titleCell.Value = reportTitle.ToUpper();
				titleCell.Style.Font.Bold = true;
				titleCell.Style.Font.FontSize = 14;
				titleCell.Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
				titleCell.Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

				// Merge ô tiêu đề dựa trên tổng số cột
				int mergeToCol = totalColumns > 3 ? totalColumns : 5;
				worksheet.Range(currentRow, startCol, currentRow, mergeToCol).Merge();
				currentRow += 2;
			}

			// Header
			int col = startCol;
			if (isIncludeSerialNumber) {
				worksheet.Cell(currentRow, col++).Value = "STT";
			}

			foreach (var header in columnMappings.Keys) {
				worksheet.Cell(currentRow, col++).Value = header;
			}

			if (!string.IsNullOrWhiteSpace(note)) {
				worksheet.Cell(currentRow, col++).Value = note;
				totalColumns++;
			}

			// Định dạng Header
			var headerRange = worksheet.Range(currentRow, startCol, currentRow, startCol + totalColumns - 1);
			headerRange.Style.Font.Bold = true;
			headerRange.Style.Font.FontColor = XLColor.White;
			headerRange.Style.Fill.BackgroundColor = XLColor.FromHtml("#217346");
			headerRange.Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
			headerRange.Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;
			headerRange.Style.Border.OutsideBorder = XLBorderStyleValues.Thin;
			headerRange.Style.Border.InsideBorder = XLBorderStyleValues.Thin;
			headerRange.Style.Alignment.WrapText = true;

			currentRow++;

			// Đệ quy để ghi dữ liệu tree
			int serial = 1;

			void WriteNode(T item, int depth) {
				int currentCol = startCol;

				// Cột Số thứ tự
				if (isIncludeSerialNumber) {
					worksheet.Cell(currentRow, currentCol++).Value = serial++;
				}

				// Các cột dữ liệu theo Mapping
				foreach (var selector in columnMappings.Values) {
					var value = selector(item, depth);
					var cell = worksheet.Cell(currentRow, currentCol);

					// Gán giá trị cho cell
					ExcelUtils.NormalizeExcelValue(cell, value);

					// Thụt lề
					// Chỉ thụt lề nếu depth > 0 và giá trị là kiểu chuỗi
					if (depth > 0 && value is string) {
						cell.Style.Alignment.Indent = depth * 2; // Mỗi cấp thụt 2 đơn vị
					}

					currentCol++;
				}

				// Định dạng dòng dữ liệu
				var rowRange = worksheet.Range(currentRow, startCol, currentRow, startCol + totalColumns - 1);
				rowRange.Style.Border.OutsideBorder = XLBorderStyleValues.Thin;
				rowRange.Style.Border.InsideBorder = XLBorderStyleValues.Thin;

				// In đậm cho Node gốc (Cấp cha cao nhất)
				if (depth == 0) {
					rowRange.Style.Font.Bold = true;
					rowRange.Style.Fill.BackgroundColor = XLColor.FromHtml("#F2F2F2");
				}

				currentRow++;

				// Gọi đệ quy cho danh sách con
				var children = childrenSelector(item);
				if (children != null) {
					foreach (var child in children) {
						WriteNode(child, depth + 1);
					}
				}
			}

			// Bắt đầu ghi từ các root items
			foreach (var rootItem in treeData) {
				WriteNode(rootItem, 0);
			}

			// 4. CĂN CHỈNH ĐỘ RỘNG CỘT TỰ ĐỘNG
			worksheet.Columns().AdjustToContents();
		}
	}
}