import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_task/bloc/sort_bloc/sort_bloc_event.dart';
import 'package:test_task/bloc/sort_bloc/sort_bloc_state.dart';
import 'package:test_task/models/spare_part_model.dart';

class SortBloc extends Bloc<SortBlocEvent, SortState> {
  SortBloc({required this.repository}) : super(InitialState()) {
    on<SortAscendingEvent>((event, emit) {
      List<SparePartModel> listAscend = state.sortedList;
      listAscend.sort((a, b) => (a.amount.compareTo(b.amount)));
      emit(AscendingSortState(listAscend));
      //emit(SortMenuCloseState());
    });
    on<SortDescendingEvent>((event, emit) {
      List<SparePartModel> listDescend = state.sortedList;
      listDescend.sort((b, a) => (a.amount.compareTo(b.amount)));
      emit(DescendingSortState(listDescend));
    });
    on<SortMenuOpenEvent>((event, emit) {
      emit(SortMenuOpenState(state.sortedList));
    });
    on<SortMenuCloseEvent>((event, emit) {
      emit(SortMenuCloseState(state.sortedList));
    });
    on<FilterMenuOpenEvent>((event, emit) {
      repository.currentQualitySelected = 'Любое качество';
      repository.currentBrandSelected = 'Все бренды';
      emit(FilterMenuOpenState(repository.originalList));
    });
    on<FilterMenuCloseEvent>((event, emit) {
      //update the state sorted list to original settings to prepare for future MenuOpenEvent
      //i.e. cancel all filters, so filter fields will be unfiltered
      emit(FilterMenuCloseState(state.sortedList));
      //reset data after menu close
      repository.currentQualitySelected = 'Любое качество';
      repository.currentBrandSelected = 'Все бренды';
      //state.sortedList = repository.originalList;
    });
    on<FilterSetEvent>((event, emit) {
      repository.qualityBool =
          repository.currentQualitySelected == 'Оригинал' ? true : false;
      List<SparePartModel> listOriginal = repository.originalList;
      late List<SparePartModel> filteredList;
      //selected flag
      repository.previousSel = true;
      if ((repository.currentBrandSelected != 'Все бренды') &&
          (repository.currentQualitySelected != 'Любое качество')) {
        filteredList = listOriginal
            .where((element) =>
                (element.brand == repository.currentBrandSelected) &&
                (element.original == repository.qualityBool))
            .toList();
      }
      //sort by Quality Only
      else if ((repository.currentBrandSelected == 'Все бренды') &&
          (repository.currentQualitySelected != 'Любое качество')) {
        filteredList = listOriginal
            .where((element) => element.original == repository.qualityBool)
            .toList();
        //selected flag
      }
      //sort by Brand only
      else if ((repository.currentBrandSelected != 'Все бренды') &&
          (repository.currentQualitySelected == 'Любое качество')) {
        filteredList = listOriginal
            .where(
                (element) => element.brand == repository.currentBrandSelected)
            .toList();
        //No filter was applied
      } else {
        //selected flag
        repository.previousSel = false;
        filteredList = listOriginal;
      }
      emit(FilterSetState(filteredList));
    });
    on<FilterBrandSelectedEvent>((event, emit) {
      repository.currentBrandSelected = event.brandFilter;
      List<SparePartModel> listFilter = state.sortedList;
      emit(FilterBrandSelectedState(listFilter));
    });
    on<FilterQualitySelectedEvent>((event, emit) {
      repository.currentQualitySelected = event.qualityFilter;
      List<SparePartModel> listFilter = state.sortedList;
      emit(FilterQualitySelectedState(listFilter));
    });
    on<FilterCancelEvent>((event, emit) {
      final originalList = repository.originalList;
      repository.currentQualitySelected = 'Любое качество';
      repository.currentBrandSelected = 'Все бренды';
      emit(FilterCancelState(originalList));
    });
  }
  final Repository repository;
}

List<SparePartModel> getDataFromServer() {
  //example data from server
  String data = '''
  [
    {
      "brand": "Toyota",
      "amount": 840,
      "original": true,
      "part_num": "9046804079",
      "top": true,
      "vcurrency": "KZT"
    },
    {
      "brand": "BMW",
      "amount": 2550,
      "original": true,
      "part_num": "9046804079",
      "top": true,
      "vcurrency": "KZT"
    },
    {
      "brand": "Toyota",
      "amount": 23450,
      "original": true,
      "part_num": "SF680F4079",
      "top": false,
      "vcurrency": "KZT"
    },
    {
      "brand": "Lexus",
      "amount": 55550,
      "original": true,
      "part_num": "SF680F4079",
      "top": true,
      "vcurrency": "KZT"
    },
    {
      "brand": "Mazda",
      "amount": 3780,
      "original": true,
      "part_num": "SF680F4079",
      "top": false,
      "vcurrency": "KZT"
    },
    {
      "brand": "Audi",
      "amount": 34550,
      "original": false,
      "part_num": "9046804079",
      "top": true,
      "vcurrency": "KZT"
    },
    {
      "brand": "Audi",
      "amount": 2500,
      "original": true,
      "part_num": "9046804079",
      "top": false,
      "vcurrency": "KZT"
    },
    {
      "brand": "Nissan",
      "amount": 2600,
      "original": true,
      "part_num": "9046804079",
      "top": true,
      "vcurrency": "KZT"
    },
    {
      "brand": "JAC",
      "amount": 3300,
      "original": true,
      "part_num": "9046804079",
      "top": true,
      "vcurrency": "KZT"
    },
    {
      "brand": "Hyundai",
      "amount": 3300,
      "original": true,
      "part_num": "9046804079",
      "top": true,
      "vcurrency": "KZT"
    }
  ]
  ''';

  late final List<SparePartModel> dbList;
  try {
    final jsonString = jsonDecode(data) as List;
    dbList = jsonString.map((e) => SparePartModel.fromJson(e)).toList();
  } catch (error) {
    print('error found $error');
  }
  return dbList;
}

class Repository {
  List<SparePartModel> loadData() => getDataFromServer();

  String defaultCurrentBrandSelected = 'Все бренды';
  String defaultCurrentQualitySelected = 'Любое качество';

  late String currentBrandSelected = defaultCurrentBrandSelected;
  late String currentQualitySelected = defaultCurrentQualitySelected;

  late bool smthSelected = (isBrandSelected || isQualitySelected);

  late bool qualityBool = currentQualitySelected == 'Оригинал' ? true : false;

  late bool isBrandSelected =
      currentBrandSelected == 'Все бренды' ? false : true;
  late bool isQualitySelected =
      currentQualitySelected == 'Любое качество' ? false : true;

  //filter status before filter window close
  late bool previousSel = false;

  //true when filter window closes
  late bool filterMenuClosed = true;

  late bool selectionTracker = previousSel && filterMenuClosed;
  //late bool selectionTracker = true;

  List<SparePartModel> originalList = getDataFromServer();

  final _myList = <SparePartModel>[];

  List<SparePartModel> currentList() => _myList;

  void sortedList() {
    _myList.sort();
  }

  void filteredList(String brandFilter, bool quality) {
    _myList.where((element) =>
        (element.brand == brandFilter) && (element.original == quality));
  }
}
