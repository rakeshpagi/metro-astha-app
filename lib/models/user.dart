class User{
    bool _isanonymous=false; 
    String id,username,mobileno; 
    User({this.id,this.username,this.mobileno}); 
    User.anonymous():this.username='Anonymous'{
        this._isanonymous=true; 
    }
    get anonymous=>this._isanonymous; 
    
    toMap()=>{"username":username,"mobileno":mobileno};
}