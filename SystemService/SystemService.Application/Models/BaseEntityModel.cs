namespace SystemService.Application.Models;

public partial record BaseEntityModel<TKey> : BaseModel
{
    public virtual TKey Id { get; set; }
}
