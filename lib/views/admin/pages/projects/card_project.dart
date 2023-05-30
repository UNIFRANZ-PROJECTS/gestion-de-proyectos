import 'package:flutter/material.dart';
import 'package:gestion_projects/components/compoents.dart';
import 'package:gestion_projects/models/models.dart';
import 'package:gestion_projects/views/admin/pages/projects/card_expanded.dart';

class ProjectWidget extends StatelessWidget {
  final ProjectModel project;

  const ProjectWidget({Key? key, required this.project}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              PageRouteBuilder(
                opaque: false,
                pageBuilder: (_, __, ___) => CardExpanded(project: project),
              ),
            );
          },
          child: LayoutBuilder(
            builder: (context, constraints) {
              return ContainerComponent(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      ClipRRect(
                        // borderRadius: const BorderRadius.all(
                        //   Radius.circular(30),
                        // ),
                        child: Image.asset(
                          'assets/images/logo-bronce.png',
                          height: constraints.maxWidth * 0.5,
                          // fit: BoxFit.,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              project.project.title,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ));
  }
}
