namespace SystemService.Application.Models.Common;

public record TreeModel<TKey>: BaseModel
{
    public TKey Value { get; set; }
    public string Text { get; set; }
    public bool HasChildren { get; set; }
    public List<TreeModel<TKey>> Children { get; set; } = new();
}

public record TreeModelCustom<TKey>: BaseModel
{
    public TKey Value { get; set; }
    public string Text { get; set; }
    public bool HasChildren { get; set; }
    public Guid? ParentId { get; set; } // dùng khi nó có cha ở 1 entiti khác ( ví dụ option Nhóm vthh sẽ thuộc 1 loại vthh=> parentId là id của loại vthh)
    public List<TreeModelCustom<TKey>> Children { get; set; } = new();
}
