using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SystemService.Application.Models
{
    public class OptionModel
    {
        public Guid Value { get; set; }
        public string Label { get; set; } = string.Empty;
    }
}
