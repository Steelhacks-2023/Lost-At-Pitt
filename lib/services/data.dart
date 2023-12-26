// ignore_for_file: slash_for_doc_comments

import 'package:lost_found_steelhacks/models/item.dart';

/**
 * Singleton service managing the current posts
 */
class DataService {

  /* Singleton setup */
  static final DataService instance = DataService._internal();
  factory DataService() => instance;
  DataService._internal();

  List<Item> lostItems = [];
  List<Item> foundItems = [];
}