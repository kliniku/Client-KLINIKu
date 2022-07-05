class categoriesModel {
  final String name;
  final String image;
  final String routeDokter;

  categoriesModel(this.name, this.image, this.routeDokter);
}

List<categoriesModel> categories = [
  categoriesModel('Umum', 'assets/icons/general.png', '/umum'),
  categoriesModel('Mata', 'assets/icons/eye.png', '/mata'),
  categoriesModel('Gigi', 'assets/icons/tooth.png', '/gigi'),
  categoriesModel('THT', 'assets/icons/tht.png', '/tht'),
  categoriesModel('Lansia', 'assets/icons/lansia.png', '/lansia'),
  categoriesModel('Ibu & Anak', 'assets/icons/pregnant.png', '/ibu_anak'),
];
