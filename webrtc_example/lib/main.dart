import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter WebRTC Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late MediaStream _localStream;
  late RTCPeerConnection _peerConnection;

  @override
  void initState() {
    super.initState();

    // Get the local media stream
    _getLocalStream().then((stream) {
      setState(() {
        _localStream = stream;
      });

      // Create the RTCPeerConnection
      _createPeerConnection().then((pc) {
        _peerConnection = pc;

        // Add the local stream to the peer connection
        _peerConnection.addStream(_localStream);
      });
    });
  }

  // Get the local media stream
  Future<MediaStream> _getLocalStream() async {
    // Get the default camera and microphone
    final camera = await getCamera();
    final microphone = await getMicrophone();

    // Generate the local media stream
    return MediaStream.fromDevices(camera: camera, microphone: microphone);
  }

  // Create the RTCPeerConnection
  Future<RTCPeerConnection> _createPeerConnection() async {
    // Set up the configuration for the peer connection
    final configuration = RTCConfiguration();

    // Create the peer connection using the configuration
    return await createPeerConnection(configuration);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter WebRTC Demo'),
      ),
      body: Center(
        child: _localStream != null
            ? RTCVideoView(_localStream)
            : CircularProgressIndicator(),
      ),
    );
  }
}
