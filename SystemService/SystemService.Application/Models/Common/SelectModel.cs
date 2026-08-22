using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SystemService.Application.Models.Common
{
    public class SelectModel
    {
        public Guid Value { get; set; }
        public string Text { get; set; }
    }

    public class SelectWithMaModel
    {
        public Guid Value { get; set; }
        public string Text { get; set; }

        public string? Ma { get; set; }
    }
}
