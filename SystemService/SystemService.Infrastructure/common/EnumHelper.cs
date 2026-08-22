using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SystemService.Application.Extensions;

namespace SystemService.Infrastructure.Common
{
    public static class EnumHelper
    {
        /// <summary>
        /// Lấy danh sách ID của Enum có Description chứa từ khóa tìm kiếm
        /// </summary>
        /// <typeparam name="T">Kiểu Enum cần search</typeparam>
        /// <param name="keyword">Từ khóa tìm kiếm (tiếng Việt)</param>
        /// <returns>Danh sách các ID (int) thỏa mãn</returns>
        public static List<int> GetIdsByDescription<T>(string keyword) where T : Enum
        {
            if (string.IsNullOrWhiteSpace(keyword)) return new List<int>();

            var searchKey = keyword.Trim().ToLower();

            return Enum.GetValues(typeof(T))
                .Cast<T>()
                .Where(e => {
                    var description = e.GetDescription();
                    return !string.IsNullOrEmpty(description) && description.ToLower().Contains(searchKey);
                })
                .Select(e => Convert.ToInt32(e))
                .ToList();
        }
    }
}
