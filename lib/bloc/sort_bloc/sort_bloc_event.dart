import 'package:equatable/equatable.dart';

abstract class SortBlocEvent extends Equatable {}

class SortAscendingEvent extends SortBlocEvent {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class SortDescendingEvent extends SortBlocEvent {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class SortMenuOpenEvent extends SortBlocEvent {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class SortMenuCloseEvent extends SortBlocEvent {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class FilterMenuOpenEvent extends SortBlocEvent {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class FilterSetEvent extends SortBlocEvent {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class FilterMenuCloseEvent extends SortBlocEvent {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class FilterBrandSelectedEvent extends SortBlocEvent {
  final String brandFilter;

  FilterBrandSelectedEvent(this.brandFilter);

  @override
  // TODO: implement props
  List<Object?> get props => [brandFilter];
}

class FilterQualitySelectedEvent extends SortBlocEvent {
  final String qualityFilter;

  FilterQualitySelectedEvent(this.qualityFilter);

  @override
  // TODO: implement props
  List<Object?> get props => [qualityFilter];
}

class FilterCancelEvent extends SortBlocEvent {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
