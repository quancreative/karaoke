
//vlc.play({'src' : 'Kalimba.mp3'});
$('#ctrl-next').click(function(){
    vlc.next();
});

//
//var firebaseRef = new Firebase('https://karaoke.firebaseio.com/');
//firebaseRef.on('value', function(dataSnapshot) {
//    var fredSnapshot = dataSnapshot;
//    var data = fredSnapshot.val();
//    // data will now contain an object like:
//    // { name: { first: 'Fred', last: 'Flintstone' }, rank: 1000 }.
//    deb.trace(data);
//    var firstNameSnapshot = fredSnapshot.child('name/first');
//    var firstName = firstNameSnapshot.val();
//    deb.trace(data.name);
//});