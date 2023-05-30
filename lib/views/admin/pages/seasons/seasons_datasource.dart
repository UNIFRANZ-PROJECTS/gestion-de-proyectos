import 'package:flutter/material.dart';
import 'package:gestion_projects/models/models.dart';

class SeasonsDataSource extends DataTableSource {
  final Function(SeasonModel) editSeason;
  final Function(SeasonModel, bool) deleteSeason;
  final Function(List<StageModel>) stages;
  final List<SeasonModel> seasons;

  SeasonsDataSource(this.seasons, this.editSeason, this.deleteSeason, this.stages);

  @override
  DataRow getRow(int index) {
    final SeasonModel season = seasons[index];
    return DataRow.byIndex(index: index, cells: [
      DataCell(Text(season.name)),
      DataCell(Text('${season.start}')),
      DataCell(Text('${season.end}')),
      DataCell(Text('${season.price}')),
      DataCell(IconButton(icon: const Icon(Icons.remove_red_eye), onPressed: () => stages(season.stagesIds))),
      DataCell(Text(season.state ? 'Activo' : 'Inactivo')),
      DataCell(Row(
        children: [
          IconButton(icon: const Icon(Icons.edit_outlined), onPressed: () => editSeason(season)),
          Transform.scale(
              scale: .5,
              child: Switch(
                  activeTrackColor: Colors.green,
                  inactiveTrackColor: Colors.red,
                  inactiveThumbColor: Colors.white,
                  activeColor: Colors.white,
                  value: season.state,
                  onChanged: (state) => deleteSeason(season, state)))
        ],
      )),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => seasons.length;

  @override
  int get selectedRowCount => 0;
}
