import 'package:equatable/equatable.dart';
import 'package:test_task/bloc/sort_bloc/sort_bloc.dart';
import 'package:test_task/models/spare_part_model.dart';

abstract class SortState extends Equatable {
  const SortState();

  get sortedList => sortedList;

  //get sortedList => sortedList;
}

class InitialState extends SortState {
  final List<SparePartModel> sortedList = getDataFromServer();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class AscendingSortState extends SortState {
  final List<SparePartModel> sortedList;
  const AscendingSortState(this.sortedList);

  @override
  // TODO: implement props
  List<Object?> get props => [sortedList];
}

class DescendingSortState extends SortState {
  final List<SparePartModel> sortedList;
  const DescendingSortState(this.sortedList);

  @override
  // TODO: implement props
  List<Object?> get props => [sortedList];
}

class SortMenuOpenState extends SortState {
  final List<SparePartModel> sortedList;
  SortMenuOpenState(this.sortedList);

  @override
  // TODO: implement props
  List<Object?> get props => [sortedList];
}

class SortMenuCloseState extends SortState {
  final List<SparePartModel> sortedList;
  SortMenuCloseState(this.sortedList);

  @override
  // TODO: implement props
  List<Object?> get props => [sortedList];
}

class FilterMenuOpenState extends SortState {
  final List<SparePartModel> sortedList;
  const FilterMenuOpenState(this.sortedList);
  @override
  // TODO: implement props
  List<Object?> get props => [sortedList];
}

class FilterSetState extends SortState {
  final List<SparePartModel> sortedList;
  const FilterSetState(this.sortedList);
  @override
  // TODO: implement props
  List<Object?> get props => [sortedList];
}

class FilterMenuCloseState extends SortState {
  final List<SparePartModel> sortedList;
  const FilterMenuCloseState(this.sortedList);
  @override
  // TODO: implement props
  List<Object?> get props => [sortedList];
}

class FilterBrandSelectedState extends SortState {
  final List<SparePartModel> sortedList;
  const FilterBrandSelectedState(this.sortedList);
  @override
  // TODO: implement props
  List<Object?> get props => [sortedList];
}

class FilterQualitySelectedState extends SortState {
  final List<SparePartModel> sortedList;
  const FilterQualitySelectedState(this.sortedList);
  @override
  // TODO: implement props
  List<Object?> get props => [sortedList];
}

class FilterCancelState extends SortState {
  final List<SparePartModel> sortedList;
  const FilterCancelState(this.sortedList);

  @override
  // TODO: implement props
  List<Object?> get props => [sortedList];
}
