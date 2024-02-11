class TaxResidenceModel {
  final String? country;
  final String? id;

  TaxResidenceModel({
    required this.country,
    required this.id,
  });

  TaxResidenceModel.copy(TaxResidenceModel source)
      : country = source.country,
        id = source.id;

  factory TaxResidenceModel.fromJson(Map<String, dynamic> json) {
    return TaxResidenceModel(
      country: json['country'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'country': country,
      'id': id,
    };
  }
}

class FileModel {
  final int id;
  final DateTime createdAt;
  final DateTime modifiedAt;
  final String fileName;
  final String dataType;
  final String? author;
  final String? state;
  final String? field;
  final String? label;
  final String? description;
  final String fileUrl;
  final bool invalid;

  FileModel({
    required this.id,
    required this.createdAt,
    required this.modifiedAt,
    required this.fileName,
    required this.dataType,
    this.author,
    this.state,
    this.field,
    this.label,
    this.description,
    required this.fileUrl,
    required this.invalid,
  });

  FileModel.copy(FileModel source)
      : id = source.id,
        createdAt = source.createdAt,
        modifiedAt = source.modifiedAt,
        fileName = source.fileName,
        dataType = source.dataType,
        author = source.author,
        state = source.state,
        field = source.field,
        label = source.label,
        description = source.description,
        fileUrl = source.fileUrl,
        invalid = source.invalid;

  factory FileModel.fromJson(Map<String, dynamic> json) {
    return FileModel(
      id: json['id'],
      createdAt: DateTime.parse(json['createdAt']),
      modifiedAt: DateTime.parse(json['modifiedAt']),
      fileName: json['fileName'],
      dataType: json['dataType'],
      author: json['author'],
      state: json['state'],
      field: json['field'],
      label: json['label'],
      description: json['description'],
      fileUrl: json['fileUrl'],
      invalid: json['invalid'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'modifiedAt': modifiedAt.toIso8601String(),
      'fileName': fileName,
      'dataType': dataType,
      'author': author,
      'state': state,
      'field': field,
      'label': label,
      'description': description,
      'fileUrl': fileUrl,
      'invalid': invalid,
    };
  }
}

class UserTaxDataModel {
  final bool usPerson;
  final String? usTaxId;
  final TaxResidenceModel primaryTaxResidence;
  final List<TaxResidenceModel> secondaryTaxResidence;
  final int w9FileId;
  final FileModel w9File;

  UserTaxDataModel({
    required this.usPerson,
    this.usTaxId,
    required this.primaryTaxResidence,
    required this.secondaryTaxResidence,
    required this.w9FileId,
    required this.w9File,
  });

  UserTaxDataModel.copy(UserTaxDataModel source)
      : usPerson = source.usPerson,
        usTaxId = source.usTaxId,
        primaryTaxResidence =
            TaxResidenceModel.copy(source.primaryTaxResidence),
        secondaryTaxResidence = List.from(source.secondaryTaxResidence
            .map((residence) => TaxResidenceModel.copy(residence))),
        w9FileId = source.w9FileId,
        w9File = FileModel.copy(source.w9File);

  factory UserTaxDataModel.fromJson(Map<String, dynamic> json) {
    var secondaryTaxResidenceJson = json['secondaryTaxResidence'] as List;
    List<TaxResidenceModel> secondaryTaxResidence = secondaryTaxResidenceJson
        .map((i) => TaxResidenceModel.fromJson(i))
        .toList();

    return UserTaxDataModel(
      usPerson: json['usPerson'],
      usTaxId: json['usTaxId'],
      primaryTaxResidence:
          TaxResidenceModel.fromJson(json['primaryTaxResidence']),
      secondaryTaxResidence: secondaryTaxResidence,
      w9FileId: json['w9FileId'],
      w9File: FileModel.fromJson(json['w9File']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'usPerson': usPerson,
      'usTaxId': usTaxId,
      'primaryTaxResidence': primaryTaxResidence.toJson(),
      'secondaryTaxResidence':
          secondaryTaxResidence.map((e) => e.toJson()).toList(),
      'w9FileId': w9FileId,
      'w9File': w9File.toJson(),
    };
  }
}
