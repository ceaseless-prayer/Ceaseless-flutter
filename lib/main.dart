import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import './tabs/home.dart' as _homeTab;
import './tabs/people.dart' as _peopleTab;
import './tabs/journal.dart' as _journalTab;
import './screens/about.dart' as _aboutPage;
import './screens/contact.dart' as _contactPage;
import './screens/help.dart' as _helpPage;
import './screens/newsletter.dart' as _newsletterPage;
import './screens/rate.dart' as _ratePage;
import './screens/settings.dart' as _settingsPage;


void main() => runApp(new MaterialApp(
  title: 'Ceaseless Prayer',
  theme: new ThemeData(
    primarySwatch: Colors.blueGrey,
    scaffoldBackgroundColor: Colors.white,
    primaryColor: Colors.blueGrey, backgroundColor: Colors.white
  ),
  home: new Tabs(),
  onGenerateRoute: (RouteSettings settings) {
    switch (settings.name) {
      case '/about': return new FromRightToLeft(
        builder: (_) => new _aboutPage.About(),
        settings: settings,
      );
      case '/contact': return new FromRightToLeft(
        builder: (_) => new _contactPage.Contact(),
        settings: settings,
      );
      case '/help': return new FromRightToLeft(
        builder: (_) => new _helpPage.Help(),
        settings: settings,
      );
      case '/newsletter': return new FromRightToLeft(
        builder: (_) => new _newsletterPage.Newsletter(),
        settings: settings,
      );
      case '/rate': return new FromRightToLeft(
        builder: (_) => new _ratePage.Rate(),
        settings: settings,
      );
      case '/settings': return new FromRightToLeft(
        builder: (_) => new _settingsPage.Settings(),
        settings: settings,
      );
    }
  },
  // routes: <String, WidgetBuilder> {
  //   '/about': (BuildContext context) => new _aboutPage.About(),
  // }
));

class FromRightToLeft<T> extends MaterialPageRoute<T> {
  FromRightToLeft({ WidgetBuilder builder, RouteSettings settings })
    : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child) {

    if (settings.isInitialRoute)
      return child;

    return new SlideTransition(
      child: new Container(
        decoration: new BoxDecoration(
          boxShadow: [
            new BoxShadow(
              color: Colors.black26,
              blurRadius: 25.0,
            )
          ]
        ),
        child: child,
      ),
      position: new Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      )
      .animate(
        new CurvedAnimation(
          parent: animation,
          curve: Curves.fastOutSlowIn,
        )
      ),
    );
  }
  @override Duration get transitionDuration => const Duration(milliseconds: 400);
}

class Tabs extends StatefulWidget {
  @override
  TabsState createState() => new TabsState();
}

class TabsState extends State<Tabs> {
  
  PageController _tabController;

  var _title_app = null;
  int _tab = 0;

  @override
  void initState() {
    super.initState();
    _tabController = new PageController();
    this._title_app = TabItems[0].title;
  }

  @override
  void dispose(){
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build (BuildContext context) => new Scaffold(

    //App Bar
    appBar: new AppBar(
      title: new Text(
        _title_app, 
        style: new TextStyle(
          fontSize: Theme.of(context).platform == TargetPlatform.iOS ? 17.0 : 20.0,
        ),
      ),
      elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
    ),

    //Content of tabs
    body: new PageView(
      controller: _tabController,
      onPageChanged: onTabChanged,
      children: <Widget>[
        new _homeTab.Home(),
        new _peopleTab.People(),
        new _journalTab.Journal()
      ],
    ),

    //Tabs
    bottomNavigationBar: Theme.of(context).platform == TargetPlatform.iOS ?
      new CupertinoTabBar(
        activeColor: Colors.blueGrey,
        currentIndex: _tab,
        onTap: onTap,
        items: TabItems.map((TabItem) {
          return new BottomNavigationBarItem(
            title: new Text(TabItem.title),
            icon: new Icon(TabItem.icon),
          );
        }).toList(),
      ):
      new BottomNavigationBar(
        currentIndex: _tab,
        onTap: onTap,
        items: TabItems.map((TabItem) {
          return new BottomNavigationBarItem(
            title: new Text(TabItem.title),
            icon: new Icon(TabItem.icon),
          );
        }).toList(),
    ),

    //Drawer
    drawer: new Drawer(
      child: new ListView(
        children: <Widget>[
          new Container(
            height: 120.0,
            child: new DrawerHeader(
              padding: new EdgeInsets.all(0.0),
              decoration: new BoxDecoration(
                color: new Color(0xFFECEFF1),
              ),
              child: new Center(
                child: new FlutterLogo(
                  colors: Colors.blueGrey,
                  size: 54.0,
                ),
              ),
            ),
          ),
          new ListTile(
            leading: new Icon(Icons.settings),
            title: new Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed('/settings');
            }
          ),
          new ListTile(
            leading: new Icon(Icons.help),
            title: new Text('Help'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed('/help');
            }
          ),
                    new ListTile(
            leading: new Icon(Icons.chat_bubble),
            title: new Text('Contact'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed('/contact');
            }
          ),
          new Divider(),
          new ListTile(
            leading: new Icon(Icons.star),
            title: new Text('Rate This App'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed('/rate');
            }
          ),
          new ListTile(
            leading: new Icon(Icons.mail),
            title: new Text('Subscribe To Newsletter'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed('/newsletter');
            }
          ),
          new ListTile(
            leading: new Icon(Icons.info),
            title: new Text('About'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed('/about');
            }
          ),
        ],
      )
    )
  );

  void onTap(int tab){
    _tabController.jumpToPage(tab);
  }

  void onTabChanged(int tab) {
    setState((){
      this._tab = tab;
    });

    switch (tab) {
      case 0:
        this._title_app = TabItems[0].title;
      break;

      case 1:
        this._title_app = TabItems[1].title;
      break;

      case 2:
        this._title_app = TabItems[2].title;
      break;
    }
  }
}

class TabItem {
  const TabItem({ this.title, this.icon });
  final String title;
  final IconData icon;
}

const List<TabItem> TabItems = const <TabItem>[
  const TabItem(title: 'Home', icon: Icons.home),
  const TabItem(title: 'People', icon: Icons.people),
  const TabItem(title: 'Journal', icon: Icons.list)
];