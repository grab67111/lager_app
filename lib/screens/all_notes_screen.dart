import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:note_app_flutter_sqflite_provider/constants/app_constants.dart';
import 'package:note_app_flutter_sqflite_provider/functions/future_functions.dart';
import 'package:note_app_flutter_sqflite_provider/providers/locale_provider.dart';
import 'package:note_app_flutter_sqflite_provider/providers/note_provider.dart';
import 'package:note_app_flutter_sqflite_provider/utils/note_search.dart';
import 'package:note_app_flutter_sqflite_provider/widgets/note_list_view_widget.dart';
import 'package:note_app_flutter_sqflite_provider/widgets/note_note_ui_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'drawer_screen.dart';
import 'edit_note_screen.dart';

class AllNotesScreen extends StatefulWidget {
  const AllNotesScreen({Key? key}) : super(key: key);

  @override
  State<AllNotesScreen> createState() => _AllNotesScreenState();
}

class _AllNotesScreenState extends State<AllNotesScreen> {
  String _viewMode = ViewMode.staggeredGrid.name;
  bool _isLoading = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isLoading == true) {
      Future.wait([
        _loadViewMode(),
        Provider.of<LocaleProvider>(context, listen: false).fetchLocale(),
        refreshOrGetData(context),
      ]).whenComplete(() {
        setState(() {
          _isLoading = false;
        });
      });
    }
  }

  Future _loadViewMode() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('view-mode')) return;
    setState(() {
      _viewMode = prefs.getString('view-mode') ?? ViewMode.staggeredGrid.name;
    });
  }

  @override
  Widget build(BuildContext context) {


     return AnnotatedRegion(
        value: const SystemUiOverlayStyle(systemNavigationBarColor:  ColorsConstant.darkDarkBlueColor),

        child: WillPopScope(

            onWillPop: () async {
              Navigator.of(context).pop();
              // deleteFileList(_tmpAddedImageFiles);
              return false;
            },
            child: Scaffold(
              backgroundColor: ColorsConstant.bgScaffoldColor,


              key: _scaffoldKey,
      appBar: AppBar(    backgroundColor:  ColorsConstant.darkBlueColor,


        systemOverlayStyle: SystemUiOverlayStyle(
          // Status bar color
          statusBarColor: ColorsConstant.darkDarkBlueColor,
          systemNavigationBarColor: ColorsConstant.darkDarkBlueColor,
          systemNavigationBarDividerColor: ColorsConstant.darkDarkBlueColor,

          // Status bar brightness (optional)

        ),
        leading: Builder(
          builder: (BuildContext context) {
            return  Padding(
                padding: const EdgeInsets.all(5.0),
                child: CircleAvatar(
                radius: 20,

                    backgroundColor:  ColorsConstant.iconCircleColor,

            child: IconButton(
              icon: const Icon(
                Icons.menu,
                color: Colors.white,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            ) )  );
          },
        ),

        // iconTheme:
        // IconThemeData(
          //    Padding(
          //     padding: const EdgeInsets.all(5.0),
          //     child: CircleAvatar(
          //     radius: 20,
          //
          //         backgroundColor:  ColorsConstant.iconCircleColor,
          //     child: IconButton(
          //   color: Colors.green),

        // backgroundColor: ColorsConstant.darkDarkBlueColor,
        title: Text(
          AppLocalizations.of(context)!.all_notes,
          style: TextStyleConstants.titleAppBarStyle,
        ),
        actions: [
          if (context.watch<NoteProvider>().items.isNotEmpty)
    Padding(
      padding: const EdgeInsets.all(5.0),
      child: CircleAvatar(
        radius: 20,

        backgroundColor:  ColorsConstant.iconCircleColor,
        child: IconButton(
              onPressed: () {
                showSearch(

                  context: context,
                  delegate: NoteSearch(isNoteByLabel: false),
                );
              },
          color: Colors.white,
              icon: const Icon(Icons.search),
        ))),
    Padding(
    padding: const EdgeInsets.all(5.0),
    child: CircleAvatar(
    radius: 20,

    backgroundColor:  ColorsConstant.iconCircleColor,
    child: IconButton(
            onPressed: () async {
              final result = await changeViewMode(_viewMode);
              setState(() {
                _viewMode = result;
              });
            },
      color: Colors.white,
            icon: _viewMode == ViewMode.staggeredGrid.name
                ? const Icon(Icons.view_stream)
                : const Icon(Icons.grid_view),
    )) ),
          const SizedBox(
            width: 6,
          )
        ],
      ),
      drawer: const DrawerScreen(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () => refreshOrGetData(context),
              child: Consumer<NoteProvider>(
                builder: (context, noteProvider, child) =>
                    noteProvider.items.isNotEmpty
                        ? NoteListViewWidget(
                            notes: noteProvider.items,
                            viewMode: _viewMode,
                            scaffoldContext: _scaffoldKey.currentContext!,
                          )
                        : child!,
                child: NoNoteUIWidget(
                  title: AppLocalizations.of(context)!
                      .your_notes_after_adding_will_appear_here,
                ),
              ),
            ),
      floatingActionButton:

            Visibility(
            visible: DrawerScreen.activ,
    child:
    FloatingActionButton(
        backgroundColor: ColorsConstant.orangeColor1,
        child: linearGradientIconAdd,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const EditNoteScreen(),
          ));
        },
    )),
    )

    )
    );









  }
}
