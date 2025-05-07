class AppConstants {

  // basic
  static const String APP_NAME = 'P2P Sharp Drop';


  static const String BASE_URL = 'https://sharp-drop.onrender.com/api';




  //auth
  static const String REGISTER_USER = '/auth/register/super';
  static const String LOGIN_USER = '/auth/login/admin';
  static const String GET_USER = '/user/profile';
  static const authToken = 'authToken';




  //admin
  static const String CREATE_CHANNEL = '/channel';
  static const String GET_CHANNEL = '/channel';
  static const String GET_PERSONAL_REFERRALS= '/user/referrals/personal';

  //chat
  static const String GET_CHAT = '/chat/admin';
  static const String GET_CHANNELS= '/channel';
  static const String GET_CHANNEL_CHAT= '/chat/v2/admin/channel/{channelId}';
  static const String GET_SENDER_CHAT= '/chat/v2/admin/chat/{chatId}';


  //messages
  static const String POST_TEXT= '/message/text';
  static const String POST_IMAGE= '/message/image';

  //order
  static const String POST_ORDER= '/order/admin';





  static const String TOKEN = 'token';

  static const String FIRST_INSTALL = 'first-install';
  static const String REMEMBER_KEY = 'remember-me';



  static String getPngAsset(String image) {
    return 'assets/images/$image.png';
  }
  static String getGifAsset(String image) {
    return 'assets/gif/$image.gif';
  }
  static String getMenuIcon(String image) {
    return 'assets/menu_icons/$image.png';
  }

}
