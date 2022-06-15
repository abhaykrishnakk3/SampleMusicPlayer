import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:rxdart/rxdart.dart';

class ScreenSecond extends StatefulWidget {
  List<SongModel> onaudio;
  int index;


  

  ScreenSecond({required this.onaudio, required this.index, Key? key})
      : super(key: key);

  @override
  State<ScreenSecond> createState() => _ScreenSecondState();
}

class _ScreenSecondState extends State<ScreenSecond> {
  static final AudioPlayer audioplay = AudioPlayer();

  bool playing = false;

  IconData iconbtn = Icons.play_arrow;
      
 
  //duration state stream
  Stream<DurationState> get _durationStateStream =>
      Rx.combineLatest2<Duration, Duration?, DurationState>(
          audioplay.positionStream,
          audioplay.durationStream,
          (position, duration) => DurationState(
              position: position, total: duration ?? Duration.zero));
      @override
  void initState() {
    clickplay();
    // TODO: implement initState
    super.initState();
    
  }     
   
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Text(widget.onaudio[widget.index].title),
          IconButton(
              onPressed: () {
                playing
                    ? audioplay.playing
                        ? {audioplay.pause(), iconbtn = Icons.play_arrow}
                        : {
                            audioplay.play(),
                            iconbtn = Icons.pause,
                          }
                    : {
                        clickplay(),
                        playing = true,
                      };
                setState(() {});
              },
              icon: Icon(iconbtn)),
          IconButton(
              onPressed: () async {
               // audioplay.play();
                 if(widget.index <widget.onaudio.length-1){
                    widget.index = widget.index+1;
                  clickplay();
                    setState(() {
                      
                    });
                 }else{
                   widget.index = 0;
                   clickplay();
                   setState(() {
                     
                   });
                 }
                
              },
              icon: const Icon(Icons.skip_next)),
          IconButton(
              onPressed: () {
               
                  if(widget.index>0){
                    widget.index = widget.index-1;
                  clickplay();
                  setState(() {
                    
                  });
                  }else{
                    widget.index= widget.onaudio.length-1;
                    clickplay();
                    setState(() {
                      
                    });
                  }
                
              },
              icon: Icon(Icons.minimize_outlined)),
          Center(
              child: Container(
            height: 300,
            width: 300,
            child: QueryArtworkWidget(
                id: widget.onaudio[widget.index].id, type: ArtworkType.AUDIO),
          )),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                //slider bar container
                Container(
                  padding: EdgeInsets.zero,
                  margin: const EdgeInsets.only(bottom: 4.0),

                  //slider bar duration state stream
                  child: StreamBuilder<DurationState>(
                    stream: _durationStateStream,
                    builder: (context, snapshot) {
                      final durationState = snapshot.data;
                      final progress = durationState?.position ?? Duration.zero;
                      final total = durationState?.total ?? Duration.zero;

                      return ProgressBar(
                        progress: progress,
                        total: total,
                        barHeight: 2.0,
                        baseBarColor: Colors.grey,
                        progressBarColor: Color.fromARGB(236, 216, 195, 195),
                        thumbColor: Colors.black.withBlue(49),
                        timeLabelTextStyle: const TextStyle(
                          fontSize: 0,
                        ),
                        onSeek: (duration) {
                          audioplay.seek(duration);
                        },
                      );
                    },
                  ),
                ),

                //position /progress and total text
                StreamBuilder<DurationState>(
                  stream: _durationStateStream,
                  builder: (context, snapshot) {
                    final durationState = snapshot.data;
                    final progress = durationState?.position ?? Duration.zero;
                    final total = durationState?.total ?? Duration.zero;

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Flexible(
                          child: Text(
                            progress.toString().split(".")[0],
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        Flexible(
                          child: Text(
                            total.toString().split(".")[0],
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }

  void clickplay() async {
    String? uri = widget.onaudio[widget.index].uri;
    await audioplay.setAudioSource(AudioSource.uri(Uri.parse(uri!)));
    audioplay.play();
    audioplay.playing;
  }

  void clickpause() async {
    String? uri = widget.onaudio[widget.index].uri;
    // await _audioplay.setAudioSource(AudioSource.uri(Uri.parse(uri!)));
    await audioplay.pause();
  }

  void pausePlay() async {
    String? uri = widget.onaudio[widget.index].uri;
    audioplay.play();
  }

  void next() async {
    if (audioplay.hasNext) {
      await audioplay.seekToNext();

      setState(() {});
    }
  }

  void back() async {
    if (audioplay.hasPrevious) {
      await audioplay.seekToPrevious();

      setState(() {});
    }
  }
}

//duration class
class DurationState {
  DurationState({this.position = Duration.zero, this.total = Duration.zero});
  Duration position, total;
}
