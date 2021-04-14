import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyric_audio/lib/Lyrics/lyric.dart';
import 'package:lyric_audio/lib/Lyrics/lyric_util.dart';
import 'package:lyric_audio/lib/playerbloc/player_event.dart';
import 'package:lyric_audio/lib/playerbloc/player_state.dart';


class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
  // bloc include event and state (left, right)

  final AudioPlayer audioPlayer = AudioPlayer(playerId: "myplayer");

  @override
  PlayerState get initialState => PlayerInit(); // state the first (gia tri ban dau)

  @override
  Stream<PlayerState> mapEventToState(PlayerEvent event) async* {
    yield PlayerLoading();
    List<Lyric> lrc = LyricUtil.formatLyric(event.props[1]);
    yield PlayerReadyState(audioPath: event.props[0], lyrics: lrc);
  }

  // have function mapEventToSate, input is event, output state new, updated state new
  // event are dispatched and then converted to states
  // Stream function is function can call 1 time, but return (yield) value several time
}
