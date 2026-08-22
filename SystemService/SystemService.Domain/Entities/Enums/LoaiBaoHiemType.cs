using System.ComponentModel;

namespace SystemService.Domain.Entities.Enums
{
    public enum LoaiBaoHiemType
    {
        [Description("Bảo hiểm xã hội")]
        BHXH = 1,
        [Description("Bảo hiểm y tế")]
        BHYT = 2,
        [Description("Bảo hiểm thất nghiệp")]
        BHTN = 3,
        [Description("Bảo hiểm tai nạn lao động")]
        BHTNLD = 4,
    }
}
