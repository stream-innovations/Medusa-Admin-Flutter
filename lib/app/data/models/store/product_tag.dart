class ProductTag {
  final String? id;
  final String? value;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final Map<String, dynamic>? metadata;

  ProductTag({
    this.id,
    this.value,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.metadata,
  });

  factory ProductTag.fromJson(Map<String, dynamic> json) {
    return ProductTag(
        id: json['id'],
        value: json['value'],
        createdAt: DateTime.tryParse(json['created_at'] ?? '')?.toLocal(),
        updatedAt: DateTime.tryParse(json['updated_at'] ?? '')?.toLocal(),
        deletedAt: DateTime.tryParse(json['deleted_at'] ?? '')?.toLocal(),
        metadata: json['metadata']);
  }

  Map<String, dynamic> toJson({bool excludeDates = false}) {
    var json = <String, dynamic>{};
    json['id'] = id;
    json['value'] = value;
    if(!excludeDates){
      json['created_at'] = createdAt.toString();
      json['updated_at'] = updatedAt.toString();
      json['deleted_at'] = deletedAt.toString();
      json['metadata'] = metadata;
    }
    return json;
  }
}
