using MediatR;
using Microsoft.AspNetCore.Identity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SystemService.Domain.Entities.Users;
using SystemService.Domain.Repositories;

namespace SystemService.Application.Models.Users
{
    public class GetUserDropdownQuery : IRequest<List<OptionModel>>
    {
    }
    public class GetUserDropdownQueryHandler
     : IRequestHandler<GetUserDropdownQuery, List<OptionModel>>
    {
        private readonly IUserRepository _userRepository;

        public GetUserDropdownQueryHandler(IUserRepository userRepository)
        {
            _userRepository = userRepository;
        }

        public async Task<List<OptionModel>> Handle(
        GetUserDropdownQuery request,
        CancellationToken cancellationToken)
        {
            //var data = await _userRepository.GetAllAsync(q =>
            //    q.OrderBy(x => x.UserName));

            //return data
            //    .Select(x => new OptionModel
            //    {
            //        Value = x.Id,
            //        Label = x.UserName + " - " + x.FullName
            //    })
            //    .ToList();

            return new List<OptionModel>();
        }
    }
}
