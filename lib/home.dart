import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import 'package:on_audio_query/on_audio_query.dart';
import 'package:sample_music_player/screen_second.dart';

class ScreenHome extends StatefulWidget {
  const ScreenHome({Key? key}) : super(key: key);

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
 final ValueNotifier<List<SongModel>> songmodelvalue = ValueNotifier([]);
  final OnAudioQuery _onquery = OnAudioQuery();

  // AudioPlayer _onaudio = AudioPlayer();

  List<SongModel> songs = [];
  
  @override
  void initState() {
    requstpermitionStorage();
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      appBar: AppBar(title: Text('Sample Music player')),
      body: ValueListenableBuilder(
        valueListenable: songmodelvalue,
        builder: (BuildContext ctx,List<SongModel> songlist, Widget? child){
       return FutureBuilder<List<SongModel>>(
          future: _onquery.querySongs(
              sortType: null, uriType: UriType.EXTERNAL, ignoreCase: true),
          builder: (context, item) {
            if (item.data == null) return const CircularProgressIndicator();
      
            // When you try "query" without asking for [READ] or [Library] permission
            // the plugin will return a [Empty] list.

            if (item.data!.isEmpty) return const Text("Nothing found!");
      
            return ListView.builder(
                itemCount: item.data!.length,
                itemBuilder: (context, index) { 
                  return ListTile(
                    title: Text(item.data![index].title),
                    onTap: () async {
                    
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (ctx) {
                        return ScreenSecond(onaudio: item.data!,index: index);
                        
                      }));
                    },
                  );
                });
          },
        
        );
        }
      ),
      
    );
  }

  void requstpermitionStorage() async {
    if (!kIsWeb) {
      bool permitionStatus = await _onquery.permissionsStatus();
      if (!permitionStatus) {
        await _onquery.permissionsRequest();
      }
    }
  }

}
