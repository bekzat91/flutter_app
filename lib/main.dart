import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'bloc/sort_bloc/sort_bloc.dart';
import 'bloc/sort_bloc/sort_bloc_event.dart';
import 'bloc/sort_bloc/sort_bloc_state.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final repository = Repository();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: BlocProvider(
          create: (_) => SortBloc(repository: repository),
          child: MyHomePage(),
        ));
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final blocData = context.read<SortBloc>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Test app for CTOgramm'),
      ),
      body: Column(
        children: [
          Header(),
          FilterSettings(),
          //SortBlocConsumer
          Expanded(
            child: BlocConsumer<SortBloc, SortState>(
              buildWhen: (previous, current) {
                if ((previous != current) &&
                        ((current is AscendingSortState) ||
                            (current is DescendingSortState)) ||
                    (current is FilterSetState) ||
                    (current is FilterCancelState)) {
                  return true;
                } else {
                  return false;
                }
              },
              builder: (context, state) => ListView.builder(
                  itemCount: state.sortedList.length,
                  itemBuilder: (context, index) {
                    final itemX = state.sortedList[index];
                    return SingleElement(itemX);
                  }),
              listener: (context, state) {
                //Open menu when up-down button is pressed
                if (state is SortMenuOpenState) {
                  showModalBottomSheet(
                      context: context,
                      builder: (_) {
                        return SortMenu(blocData: blocData);
                      }).whenComplete(() {
                    blocData.add(SortMenuCloseEvent());
                  });
                  //open filter menu when filter icon is pressed
                } else if (state is FilterMenuOpenState) {
                  showModalBottomSheet(
                      context: context,
                      builder: (_) {
                        return BlocProvider.value(
                            value: BlocProvider.of<SortBloc>(context),
                            child: FilterMenu());
                      }).whenComplete(() {
                    blocData.add(FilterMenuCloseEvent());
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class FilterMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 358,
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: 46,
          top: 14.5,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      context.read<SortBloc>().add(FilterCancelEvent());
                    },
                    child: const Text(
                      'Очистить',
                      style: TextStyle(
                        color: Color(0xFF0C73FE),
                      ),
                    ),
                  ),
                  Text('Фильтры'),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: SvgPicture.asset(
                      'assets/icons/xmark_icon.svg',
                      height: 24,
                      width: 24,
                    ),
                  )
                ],
              ),
            ),
            BrandFilterPicker(
              header: 'Бренд',
              hint: 'Все бренды',
            ),
            QualityFilterPicker(header: 'Качество', hint: 'Любое качество'),
            TextButton(
              onPressed: () {
                context.read<SortBloc>().add(FilterSetEvent());
                Navigator.pop(context);
              },
              child: Container(
                height: 44,
                width: 343,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Показать результаты',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  color: Color(0xFF0C73FE),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SortMenu extends StatelessWidget {
  const SortMenu({
    Key? key,
    required this.blocData,
  }) : super(key: key);

  final SortBloc blocData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 20),
      child: Container(
        height: 190,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Сортировка',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: SvgPicture.asset(
                    'assets/icons/xmark_icon.svg',
                    height: 24,
                    width: 24,
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                blocData.add(SortAscendingEvent());
              },
              child: Container(
                child: Row(
                  children: [const Text('Сначала дешевые')],
                ),
              ),
            ),
            const Divider(
              thickness: 2,
              height: 3,
              color: Color(0xFFD7D8D9),
            ),
            GestureDetector(
              onTap: () {
                blocData.add(SortDescendingEvent());
              },
              child: Row(
                children: [const Text('Сначала дорогие')],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BrandFilterPicker extends StatefulWidget {
  final String header;
  final String hint;

  BrandFilterPicker({required this.header, required this.hint});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _BrandFilterPickerState();
  }
}

class _BrandFilterPickerState extends State<BrandFilterPicker> {
  @override
  void initState() {
    super.initState();
  }

  String dropdownvalue = 'Все бренды';

  @override
  Widget build(BuildContext context) {
    //get latest list
    var items = context.read<SortBloc>().state.sortedList;

    //remove duplicates from list for better filtering
    List<String> items1 =
        items.map<String>((e) => e.brand as String).toSet().toList();

    items1.add('Все бренды');

    //String dropdownvalue = items1[0];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.header),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              color: Color(0xFFF5F5F5)),
          width: 343,
          height: 44,
          child: Padding(
            padding: EdgeInsets.all(12),
            child: DropdownButton(
              underline: SizedBox.shrink(),
              hint: Text(widget.hint),
              isExpanded: true,
              value: dropdownvalue,
              // Array list of items
              items: items1
                  .map<DropdownMenuItem<String>>(
                      (String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ))
                  .toList(),
              // After selecting the desired option,it will
              // change button value to selected value
              onChanged: (String? newValue) {
                setState(() {
                  dropdownvalue = newValue!;
                  context
                      .read<SortBloc>()
                      .add(FilterBrandSelectedEvent(dropdownvalue));
                });
                //value = newValue!;
              },
            ),
          ),

          //decoration: kTextFieldDecoration,
        ),
      ],
    );
  }
}

class QualityFilterPicker extends StatefulWidget {
  final String header;
  final String hint;

  QualityFilterPicker({required this.header, required this.hint});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _QualityFilterPickerState();
  }
}

class _QualityFilterPickerState extends State<QualityFilterPicker> {
  @override
  void initState() {
    super.initState();
  }

  String dropdownvalue = 'Любое качество';

  @override
  Widget build(BuildContext context) {
    //get latest list
    var items = context.read<SortBloc>().state.sortedList;

    //remove duplicates from list for better filtering
    List<String> items1 = items
        .map<String>((e) => e.original ? 'Оригинал' : 'Дубликат' as String)
        .toSet()
        .toList();

    items1.add('Любое качество');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.header),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              color: Color(0xFFF5F5F5)),
          width: 343,
          height: 44,
          child: Padding(
            padding: EdgeInsets.all(12),
            child: DropdownButton(
              underline: SizedBox.shrink(),
              hint: Text(widget.hint),
              isExpanded: true,
              value: dropdownvalue,
              // Array list of items
              items: items1
                  .map<DropdownMenuItem<String>>(
                      (String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ))
                  .toList(),
              // After selecting the desired option,it will
              // change button value to selected value
              onChanged: (String? newValue) {
                setState(() {
                  dropdownvalue = newValue!;
                  context
                      .read<SortBloc>()
                      .add(FilterQualitySelectedEvent(dropdownvalue));
                });
                //value = newValue!;
              },
            ),
          ),

          //decoration: kTextFieldDecoration,
        ),
      ],
    );
  }
}

class SingleElement extends StatelessWidget {
  final dynamic item;

  const SingleElement(this.item);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/images/image-block.png',
                  width: 100,
                  height: 100,
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.check),
                          Text('Выбор CTOgram'),
                        ],
                      ),
                      Text('Запчасть для ${item.brand}'),
                      Row(
                        children: [
                          SvgPicture.asset(
                            item.original
                                ? 'assets/icons/checkmark_original.svg'
                                : 'assets/icons/checkmark_duplicate.svg',
                            width: 14,
                            height: 14,
                            color: item.original ? Colors.green : Colors.yellow,
                          ),
                          Text(item.original ? 'Оригинал' : 'Дубликат'),
                        ],
                      ),
                      Text('Номер запчасти ${item.part_num}'),
                      Text(
                        'Количество: ${item.amount.toString()}',
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '${item.amount} т',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      //margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      padding: const EdgeInsets.only(
                          left: 4, top: 4, right: 4, bottom: 4),
                      width: 75,
                      height: 22,
                      child: const Text(
                        'В наличии',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      //color: Color(0xFF48CA64),
                      decoration: const BoxDecoration(
                        color: Color(0xFF48CA64),
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text('Доставка за 2 часа'),
                    //Text(''),
                    Container(
                      width: 140,
                      height: 44,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          StockButton(() {}, 'assets/icons/vector_minus.svg', 2,
                              16, Colors.white, const Color(0xFF0C73FE)),
                          const Text('1'),
                          StockButton(() {}, 'assets/icons/vector_plus.svg', 16,
                              16, const Color(0xFF0C73FE), Colors.white),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: 2,
            color: const Color(0xFF1313131A),
          )
        ],
      ),
    );
  }
}

class StockButton extends StatelessWidget {
  //either add or remove action
  final VoidCallback onPressed;
  final String action;
  final double sizeWidth;
  final double sizeHeight;
  final Color backgroundColor;
  final Color signColor;

  StockButton(this.onPressed, this.action, this.sizeHeight, this.sizeWidth,
      this.backgroundColor, this.signColor);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(12)),
        border: Border.all(
          color: signColor,
        ),
      ),
      height: 44,
      width: 44,
      //color: Color(0xFF0C73FE),
      child: IconButton(
        onPressed: () {},
        icon: SvgPicture.asset(
          action,
          height: sizeHeight,
          width: sizeWidth,
          color: signColor,
        ),
      ),
    );
  }
}

//Filter settings area
class FilterSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //final filterBloc = context.read<FilterBloc>();
    final blocData = context.read<SortBloc>();
    return Container(
      height: 58,
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 7, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Container(
                height: 44,
                //color: Color(0xFFF5F5F5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  color: Color(0xFFF5F5F5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        //filterBloc.add(FilterMenuOpenEvent());
                        blocData.add(FilterMenuOpenEvent());
                      },
                      child: Container(
                        width: 40,
                        child: SvgPicture.asset(
                          'assets/icons/filter_icon.svg',
                          height: 24,
                          width: 24,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Row(children: [
                        Expanded(child: Text('Фильтры')),
                        SvgPicture.asset('assets/icons/checkmark_icon.svg'),
                      ]),
                    ),
                    GestureDetector(
                      onTap: () {
                        context.read<SortBloc>().add(FilterCancelEvent());
                      },
                      child: Container(
                        child: SvgPicture.asset(
                          'assets/icons/xmark_icon.svg',
                          width: 18,
                          height: 18,
                        ),
                        width: 40,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  //filterBloc.add(SortMenuOpenEvent());
                  blocData.add(SortMenuOpenEvent());
                },
                child: Container(
                    height: 44,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      color: Color(0xFFF5F5F5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          child:
                              SvgPicture.asset('assets/icons/updown_icon.svg'),
                          width: 40,
                        ),
                        const Text('Сортировать'),
                      ],
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//App header
class Header extends StatelessWidget {
  const Header({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SvgPicture.asset(
          'assets/icons/arrow_back_ios.svg',
          height: 24,
          width: 24,
          color: Colors.black,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Склады'),
            Row(
              children: const [
                Icon(Icons.location_on_outlined),
                Text('Алматы'),
                Icon(Icons.arrow_drop_down),
              ],
            ),
          ],
        ),
        const Icon(Icons.shopping_cart),
      ],
    );
  }
}
