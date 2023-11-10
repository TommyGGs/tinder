
  const peer = new Peer({
    key: 'c1ab4fe5-03d6-4c46-922c-99ad7de91a9b',
    debug: 3
  });
  peer.on('open', () => {
    document.getElementById('my-id').textContent = peer.id;
});
  // 発信処理
document.getElementById('make-call').onclick = () => {
  const theirID = document.getElementById('their-id').value;
  const mediaConnection = peer.call(theirID, localStream);
  setEventListener(mediaConnection);
};

// イベントリスナを設置する関数
const setEventListener = mediaConnection => {
  mediaConnection.on('stream', stream => {
    // video要素にカメラ映像をセットして再生
    const videoElm = document.getElementById('their-video')
    videoElm.srcObject = stream;
    videoElm.play();
  });
}
  peer.on('call', mediaConnection => {
    mediaConnection.answer(localStream);
    setEventListener(mediaConnection);
  });
  
  peer.on('error', err => {
    alert(err.message);
});
  
  peer.on('close', () => {
  alert('通信が切断しました。');
});
  
  