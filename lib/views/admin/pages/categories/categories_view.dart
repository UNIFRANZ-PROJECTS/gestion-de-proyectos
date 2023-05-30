import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestion_projects/bloc/blocs.dart';
import 'package:gestion_projects/components/compoents.dart';
import 'package:gestion_projects/components/inputs/search.dart';
import 'package:gestion_projects/models/models.dart';
import 'package:gestion_projects/views/admin/pages/categories/add_category.dart';
import 'package:gestion_projects/views/admin/pages/categories/categories_datasource.dart';
import 'package:gestion_projects/services/cafe_api.dart';
import 'package:gestion_projects/services/services.dart';

class CategoriesView extends StatefulWidget {
  const CategoriesView({super.key});

  @override
  State<CategoriesView> createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView> {
  TextEditingController searchCtrl = TextEditingController();
  bool searchState = false;
  @override
  void initState() {
    super.initState();
    callAllCategories();
  }

  callAllCategories() async {
    debugPrint('obteniendo todos las categorías');
    CafeApi.configureDio();
    final categoryBloc = BlocProvider.of<CategoryBloc>(context, listen: false);
    return CafeApi.httpGet(categories(null)).then((res) async {
      final elements = listElementModelFromJson(json.encode(res.data['categories']));
      categoryBloc.add(UpdateListCategory(elements));
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final categoryBloc = BlocProvider.of<CategoryBloc>(context, listen: true).state;
    List<ElementModel> listCategory = categoryBloc.listCategory;
    if (searchState) {
      listCategory = categoryBloc.listCategory
          .where((e) => e.name.trim().toUpperCase().contains(searchCtrl.text.trim().toUpperCase()))
          .toList();
    }

    final usersDataSource = CategoriesDataSource(
      listCategory,
      (typeUser) => showEdittypeUser(context, typeUser),
      (typeUser, state) => deleteTypeUser(typeUser, state),
    );
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (size.width > 1000) const Text('Categorias'),
              SearchWidget(
                controllerText: searchCtrl,
                onChanged: (value) {
                  if (value.trim().isNotEmpty) {
                    setState(() => searchState = true);
                  } else {
                    setState(() => searchState = false);
                  }
                },
              ),
              ButtonComponent(text: 'Nueva categoría', onPressed: () => showCreateTypeUser(context)),
            ],
          ),
          Expanded(
            child: ListView(
              children: [
                PaginatedDataTable(
                  sortAscending: categoryBloc.ascending,
                  sortColumnIndex: categoryBloc.sortColumnIndex,
                  columns: [
                    DataColumn(
                        label: const Text('Nombre'),
                        onSort: (index, _) {
                          // typeUserBloc.add(UpdateSortColumnIndexTypeUser(index));
                        }),
                    const DataColumn(label: Text('Estado')),
                    const DataColumn(label: Text('Acciones')),
                  ],
                  source: usersDataSource,
                  onPageChanged: (page) {
                    debugPrint('page: $page');
                  },
                )
              ],
            ),
          )
        ]));
  }

  showCreateTypeUser(BuildContext context) {
    return showDialog(
        context: context, builder: (BuildContext context) => const DialogWidget(component: AddCategoryForm()));
  }

  showEdittypeUser(BuildContext context, ElementModel element) {
    return showDialog(
        context: context, builder: (BuildContext context) => DialogWidget(component: AddCategoryForm(item: element)));
  }

  deleteTypeUser(ElementModel element, bool state) {
    final categoryBloc = BlocProvider.of<CategoryBloc>(context, listen: false);
    CafeApi.configureDio();
    FocusScope.of(context).unfocus();
    final Map<String, dynamic> body = {
      'state': state,
    };
    return CafeApi.put(categories(element.id), body).then((res) async {
      final element = elementModelFromJson(json.encode(res.data['categoria']));
      categoryBloc.add(UpdateItemCategory(element));
    }).catchError((e) {
      debugPrint('e $e');
      debugPrint('error en en : ${e.response.data['errors'][0]['msg']}');
      callDialogAction(context, '${e.response.data['errors'][0]['msg']}');
    });
  }
}
