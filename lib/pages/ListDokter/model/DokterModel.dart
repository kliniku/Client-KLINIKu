class DokterModel {
  String? noDokter;
  String? nama;
  String? spesialis;
  String? jamKerja;
  String? hariKerja;
  String? noHp;
  String? deskripsi;

  DokterModel(
      {this.jamKerja,
      this.nama,
      this.noHp,
      this.spesialis,
      this.hariKerja,
      this.noDokter,
      this.deskripsi});

  // Terima data dari server
  factory DokterModel.fromMap(map) {
    return DokterModel(
        noDokter: map['noDokter'],
        nama: map['nama'],
        spesialis: map['spesialis'],
        deskripsi: map['deskripsi'],
        jamKerja: map['namaDepan'],
        hariKerja: map['namaBelakang'],
        noHp: map['noHp']);
  }

  Map<String, dynamic> toMap() {
    return {
      'noDokter': noDokter,
      'nama': nama,
      'jamKerja': jamKerja,
      'hariKerja': hariKerja,
      'spesialis': spesialis,
      'deskripsi': deskripsi,
      'noHp': noHp
    };
  }
}
