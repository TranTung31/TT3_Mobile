namespace Shared.Audit.Kafka;

public class KafkaOptions
{
    public string BootstrapServers { get; set; } = string.Empty;
    public string SecurityProtocol { get; set; } = string.Empty;
    public KafkaTopics Topics { get; set; } = new();
    public KafkaProducerOptions Producer { get; set; } = new();
    public KafkaConsumers Consumers { get; set; } = new();
}

public class KafkaTopics
{
    public string AuditLog { get; set; } = "audit-logs-default";
    public string OrderProcessing { get; set; } = string.Empty;
    public string DanhMucInbox { get; set; } = string.Empty;
    public string DanhMucDonVi { get; set; } = string.Empty;
    public string DanhMucLoaiKhoan { get; set; } = string.Empty;
    public string DanhMucNguonVon { get; set; } = string.Empty;
    public string DanhMucNoiDungThu { get; set; } = string.Empty;
    public string DanhMucPhongBan { get; set; } = string.Empty;
    public string DanhMucDonViThanhVien { get; set; } = string.Empty;
    public string DanhMucNhiemVuChi { get; set; } = string.Empty;
    public string DanhMucMucTieuMuc { get; set; } = string.Empty;
    public string StorageDelete { get; set; } = "storage-delete-topic";
}

public class KafkaProducerOptions
{
    public string Acks { get; set; } = "All";
    public int MessageTimeoutMs { get; set; } = 30000;
    public int Retries { get; set; } = 5;
}

public class KafkaConsumers
{
    public KafkaConsumerDetailOptions Audit { get; set; } = new();
    public KafkaConsumerDetailOptions DanhMucInbox { get; set; } = new();
    public KafkaConsumerDetailOptions DanhMucDonVi { get; set; } = new();
    public KafkaConsumerDetailOptions DanhMucLoaiKhoan { get; set; } = new();
    public KafkaConsumerDetailOptions DanhMucNguonVon { get; set; } = new();
    public KafkaConsumerDetailOptions DanhMucNoiDungThu { get; set; } = new();
    public KafkaConsumerDetailOptions DanhMucPhongBan { get; set; } = new();
    public KafkaConsumerDetailOptions DanhMucDonViThanhVien { get; set; } = new();
    public KafkaConsumerDetailOptions DanhMucNhiemVuChi { get; set; } = new();
    public KafkaConsumerDetailOptions DanhMucMucTieuMuc { get; set; } = new();
    public KafkaConsumerDetailOptions StorageDelete { get; set; } = new();
}

public class KafkaConsumerDetailOptions
{
    public string ConsumerGroupId { get; set; } = string.Empty;
    public bool EnableAutoCommit { get; set; }
    public string AutoOffsetReset { get; set; } = "Earliest";
}
