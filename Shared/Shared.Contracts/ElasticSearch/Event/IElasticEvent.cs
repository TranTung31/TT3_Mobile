using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Shared.Contracts.ElasticSearch.Event
{
    public interface IElasticEvent
    {
        Guid Id { get; }
    }
}
