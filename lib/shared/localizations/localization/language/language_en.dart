import 'languages.dart';

class LanguageEn extends Languages {
  @override
  Map get setting => {
        'labelSelectLanguage': 'Select Language',
        'settingLabel': 'Setting',
        'password': 'Change Password',
        'notification': 'Notification',
        'language': 'Language',
        'logOut': 'Log Out',
        'faceBook': 'FaceBook',
        'twitter': 'Twitter',
        'whatsApp': 'WhatsApp',
        'shareApp': 'Share App'
      };

  @override
  Map get changePassword => {
        'oldPasswordLabel': 'Old Password',
        'oldPasswordHint': 'write old password',
        'newPasswordLabel': 'New Password',
        'newPasswordHint': 'write new password',
        'confirmPasswordLabel': 'Confirm Password',
        'ConfirmPasswordHint': 'rewrite new password',
        'doneBtn': 'Change',
      };

  @override
  List get introInformation => [
        {
          'headTxt': 'The Initial Diagnosis With ML',
          'subTxt':
              'Initial diagnosis of the disease with ML is due to breaching the rumors and analyzes of the patient .'
        },
        {
          'headTxt': 'Easy Booking And Nominating',
          'subTxt':
              'Helping patients with reservations easily and nominating the appropriate doctor through the symptoms of the patient.'
        },
        {
          'headTxt': 'Keeping Previous Statements',
          'subTxt': 'Keeping all previous patient statements and analyzes.'
        },
      ];

  @override
  String get introSkip => 'Skip';

  @override
  Map get signIn => {
        'welcome': 'Welcome Back!',
        'email': 'Email Address',
        'emailHint': 'enter your email',
        'password': 'Password',
        'passwordHint': 'enter your password',
        'forgetPassword': 'Forget Password',
        'signButtonTxt': 'Sign In',
        'orSignWith': 'Or Sign In With',
        'dontHaveAccount': 'Don\'t have an account',
        'signUpTxt': 'Sign Up',
        'loggedOutSuccess': 'Logged Out Successfully'
      };

  @override
  Map get forgetPasswordScreen => {
        'header': 'Forgot password ?',
        'emailSubTxt':
            'Enter your email and we will send \n code to your mail.',
        'emailLabel': 'Email Address',
        'emailHint': 'enter your email',
        'nextBTN': 'Next',
        'dontHaveAccount': 'Don\'t have an account',
        'signUpTxt': 'Sign Up',
        'codeSubTxt': 'Enter The Code that you received \nit in email.',
        'codeLabel': 'Code',
        'CodeHint': 'enter Code',
        'verifyBTN': 'Verify',
        'passwordLabel': 'Password',
        'passwordHint': 'enter your password',
        'confirmPassword': 'Confirm Password',
        'confirmPasswordHint': 'confirm your password',
        'newPassHint': 'Make new password',
        'changeBTN': 'Change'
      };

  @override
  Map get signUp => {
        'doctorBTN': 'Doctor',
        'patientBTN': 'Patient',
        'name': 'Name',
        'nameHint': 'enter your name',
        'email': 'Email Address',
        'emailHint': 'enter your email',
        'password': 'Password',
        'passwordHint': 'enter your password',
        'confirmPassword': 'Confirm Password',
        'confirmPasswordHint': 'confirm your password',
        'signButtonTxt': 'Sign Up',
        'orSignWith': 'Or Sign Up With',
        'dontHaveAccount': 'Have an account',
        'signUpTxt': 'Sign In'
      };

  @override
  Map get signUpPatientInfo => {
        'header': 'You\'re Almost Done!',
        'addressLabel': 'Address',
        'addressHint': 'enter your address',
        'phoneLabel': 'Phone',
        'phoneHint': 'enter your phone',
        'DateLabel': 'Date Of Birth',
        'helperText': 'Select Date Of Birth',
        'genderLabel': 'Gender',
        'genderHint': 'Select Gender',
        'subText': 'By pressing “Done” you agree to our',
        'terms': 'terms & conditions',
        'infoAboutYou': 'Information About You',
        'infoAboutYouHint': 'type any information',
        'done': 'Done'
      };

  @override
  Map get uploadUserAvatar => {
        'welcome': 'Welcome To',
        'subText': 'You can add your profile picture \nto show it to others .',
        'takePhoto': 'Take New Profile Picture',
        'selectGallery': 'Select Picture From Gallery',
      };

  @override
  String get saveButton => 'Save';
  String get cancelBTN => 'Cancel';
  String get closeButton => 'Close';

  @override
  Map get signUpDoctorInfo => {
        'header': 'You\'re Almost Done!',
        'phoneLabel': 'Phone',
        'phoneHint': 'enter your phone',
        'genderLabel': 'Gender',
        'genderHint': 'Select Gender',
        'DateLabel': 'Date Of Birth',
        'helperText': 'Select Date Of Birth',
        'specialistLabel': 'Specialist',
        'specialistHint': 'Select Your Specialist',
        'clinicLocationLabel': 'Clinic Location',
        'clinicLocationHint': 'enter your clinic Location',
        'clinicDaterHeader': 'Enter Dates Clinic Available',
        'infoAboutYou': 'Information About You',
        'infoAboutYouHint': 'type any information',
        'subText': 'By pressing “Done” you agree to our',
        'terms': 'terms & conditions',
        'submit': 'Submit'
      };

  @override
  Map get updateDoctorDates => {
        'tittle': 'Update Dates',
        'Add': 'Add Clinic Dates :',
        'clinicOpen': 'Day Clinic Open In :',
        'dayHint': 'Select Day Clinic Open In',
        'from': 'From :',
        'fromHelper': 'Enter Time Clinic Opens In',
        'to': 'To :',
        'toHelper': 'Enter Time Clinic Close In',
        'addBTN': 'Add Date',
        'yourDates': 'Your Clinic Dates',
        'noDates': 'No Dates yet , add dates '
      };

  @override
  Map get notificationScreen =>
      {'tittle': 'Notifications', 'no notification': ' No Notification Yet','txt':' finished his session with you can rate it now !!'};

  @override
  Map get rateScreen => {
        'reviewLabel': 'Review',
        'reviewHint': "Write a review about doctor ...",
        'done': "Done",
      };

  @override
  Map get patientHome => {
        'clinics': 'Clinics',
        'viewAllBTN': 'view all',
        'topDoctors': 'Top Doctors',
        'snackBarLabel': 'Appointment Has Booked',
        'snackBarBTN': 'Show',
      };

  @override
  Map get allClinicsScreen => {
        'tittle': 'All Clinics',
        'brain': 'Brain Clinic',
        'brainDoctors': 'Brain Doctors',
        'chest': 'Chest Clinic',
        'chestDoctors': 'Chest Doctors',
        'physical': 'Physical Clinic',
        'physicalDoctors': 'Physical Doctors',
        'bone': 'Bone Clinic',
        'boneDoctors': 'Bone Doctors',
        'urology': 'Urology Clinic',
        'urologyDoctors': 'Urology Doctors',
        'surgery': 'Surgery Clinic',
        'surgeryDoctors': 'Surgery Doctors',
        'teeth': 'Teeth Clinic',
        'teethDoctors': 'Teeth Doctors',
        'internal': 'Internal Medicine',
        'internalDoctors': 'Internal Doctors',
        'heart': 'Heart Clinic',
        'heartDoctors': 'Heart Doctors',
        'kids': 'Kids Clinic',
        'kidsDoctors': 'Kids Doctors',
        'dermatology': 'Dermatology Clinic',
        'dermatologyDoctors': 'Dermatology Doctors',
        'mlHeader': 'Diagnosis disease with ML',
        'all': 'All',
        'noDoctorsFound':'No Doctors Found',
      };
  @override
  Map get search => {
        'txt hint': 'search Doctor',
        'what search for': 'What are \n you searching for ?',
        'search for':
            'search for your favourite doctors or \n find similar result in this area ',
        'no result': 'No Result For'
      };

  @override
  Map get doctorDetails => {
        'about': 'About',
        'clinicAppointments': 'Clinic Appointments',
        'patientReviews': 'Patient Reviews',
        'bookBtn': 'Book Appointment',
        'snackBarAddLabel': 'Added To Favorite',
        'snackBarAddBTN': 'Show',
        'snackBarRemove': 'Removed From Favorite',
        'reviewsTittle': 'Reviews',
      };

  @override
  Map get drawer => {
        'menu': 'Menu',
        'appointments': 'My Appointments',
        'profile': 'Profile',
        'favoriteDoc': 'Favorite Doctors',
        'setting': 'Setting',
        'about': 'About',
        'usingAi': 'Using AI',
      };

  @override
  Map get bookAppointment => {
        'appointmentDateLabel': 'Appointment Date',
        'appointmentDateHint': 'Select Appointment Date',
        'appointmentTimeLabel': 'Appointment Time',
        'appointmentTimeHint': 'Time That Clinic Available',
        'nameLabel': 'Name',
        'nameHint': 'Write Patient Name',
        'genderLabel': 'Gender',
        'genderHint': 'gender',
        'phoneLabel': 'Phone',
        'phoneHint': 'Write Phone',
        'appointmentNote': 'Appointment Note',
        'appointmentNoteHint': "Write your Note ...",
        'bookBTN': 'Book Appointment',
        'editBTN': 'Edit',
        'deleteBTN': 'Delete',
        'cancelBtn': 'Cancel',
        'saveBTN': 'Save',
        'day': 'Day',
        'hintDay': 'Select Day',
        'time': 'Time',
        'hintTime': 'Select Time',
        'note': 'Note : you can edit only appointment date and time',
    'editText':'Appointment Edited Successfully'
      };
  @override
  Map get ml => {
        'tapToSelect': 'Tap To Select Image ',
    'analysing':' Analysing',
    'analysis':'Analysis',
    'covidModel':'Covid-19\n Model',
    'brainModel':'Brain Model',
    'covidAccuracy':'Model Accuracy 95%',
    'brainAccuracy':'Model Accuracy 97.5%',
    'covid':'It illustrates your disease from 3 diseases Covid-19 or Viral  Pneumonia or Normal.',
    'brain':' It illustrates your disease from 3 diseases Glioma or Meningioma or Pituitary.',
    'thankyou':'Thank you for using',
    'pleaseClick':'Please click on the file and choose the -ray image',
    'explainCovid':'Explain Covid-19 Model',
'end' : 'End'
      };

  @override
  Map get allDoctors => {
        'allTap': 'All',
        'brain': 'Brain',
        'chest': 'Chest',
        'physical': 'Physical',
        'bone': 'Bone',
        'internalMedicine': 'Internal Medicine',
        'surgery': 'Surgery',
        'teeth': 'Teeth',
        'urology': 'Urology',
        'heart': 'Heart',
        'kids': 'Kids',
        'dermatology': 'dermatology',
        'bookBtn': 'Book'
      };

  @override
  Map get patientAppointments => {
        'myAppointmentTap': 'My Appointments',
        'previousTap': 'Previous',
        'detailsBTN': 'Appointment Details',
        'showMoreBTN': 'Show More',
        'no appointments': 'No Appointments Yet',
        'noPreviousAppointments': 'No Previous Appointments Yet '
      };
  @override
  Map get previousAppointmentDetails => {
        'tittle': 'Details',
        'diagnosis': 'Diagnosis',
        'medicines': 'medicines',
        'files': 'Files'
      };

  @override
  Map get favoriteDoctors => {
        'tittle': 'Favorite Doctors',
        'bookBTN': 'Book',
        'noFav': 'No Doctors in Favourite '
      };

  @override
  Map get aboutScreen => {
        'about': 'About',
        'version': 'Version',
        'termsOfUse': 'Terms Of Use',
        'contactUS': 'Contact US',
        'faceBook': 'FaceBook',
        'twitter': 'Twitter',
        'gmail': 'Gmail',
        'whatsApp': 'WhatsApp',
      };

  @override
  Map get termsOfUse => {
        'tittle': 'Terms Of Use',
        'termsSubTxt':
            "These Terms of Use govern your use of MEGA MAR,and any information, text, graphics, photos or other materials uploaded, downloaded or appearing on the the medical solution,referencing these Terms. You can’t use our the medical solution  unless you agree to them, so please read them carefully. Before using any of the the medical solution , you are required to read, understand and agree to these terms. You may only access the medical solution after reading and accepting these Terms of Use.",
        'privacy': 'Privacy',
        'privacySubTxt':
            "The medical solution Privacy Policy is incorporated into these Terms. By accepting these Terms, you agree to the collection, use, and sharing of your information through the Services in accordance with the Privacy Policy,",
        'userContent': 'User Content',
        'userContentSubTxt':
            "The Services consist of interactive features and areas that allow users to create, post, transmit, and/or store content, including but not limited to photos, videos, text, graphics, items, or other materials (collectively,) . You understand that you are responsible for all data charges you incur by using the Services. You also understand that your User Content may be viewable by others and that you have the ability to control who can access such content by adjusting your privacy settings. And you agree to abide by our Community Guidelines, which may be updated from time to time.",
        'feedback': 'feedback',
        'feedbackSubTxt':
            "You agree that any feedback, suggestions, ideas, or other information or materials regarding SNOW or the Services that you provide, whether by email or otherwise (Feedback), are non-confidential and shall become the sole property of SNOW. We will be entitled to the unrestricted use and dissemination of such Feedback for any purpose, commercial or otherwise, without acknowledging or compensating you. You waive any rights you may have to the Feedback (including any copyrights or moral rights). We like hearing from users, but please do not share your ideas with us if you expect to be paid or want to continue to own or claim rights in them.",
      };

  @override
  Map get patientProfile => {
        'phoneLabel': 'Phone',
        'phoneHint': 'enter your phone',
        'email': 'Email Address',
        'emailHint': 'enter your email',
        'addressLabel': 'Address',
        'addressHint': 'enter your address',
        'DateLabel': 'Date Of Birth',
        'helperText': 'Select Date Of Birth',
        'genderLabel': 'Gender',
        'genderHint': 'Select Gender',
        'cancelBtn': 'Cancel',
        'saveBtn': 'Save',
        'about': 'about',
        'name': 'name'
      };

  @override
  Map get doctorHome => {
        'todayTap': 'Today',
        'allTap': 'All',
        'showBtn': 'Show',
        'allAppointments': 'All Appointments',
        'appointment of': 'Appointments',
    'NoAppointments':'No Appointments in \n'
      };

  @override
  Map get doctorUpcomingMeeting => {
        'tittle': 'Meeting',
        'delayBtn': 'Delay',
        'startBtn' : 'Start Meeting',
        'about': 'About',
        'delayAlertDateLabel': 'Date',
        'delayAlertDateHint': 'Select Appointment Date',
        'delayAlertTimeLabel': 'Time',
        'delayAlertCancelBtn': 'Cancel',
        'delayAlertDoneBtn': 'Done',
        'delayAlertDeleteBtn': 'Delete Meeting',
        'comment': 'Comment',
        'startNote': 'You Can Only Start Meeting In'
      };

  @override
  Map get doctorStartMeeting => {
        'tittle': 'Meeting',
        'addDiagnosis': 'Add a diagnosis',
        'addMedicine': 'Add a Medicine',
        'addFiles': 'Add a Files',
        'recentFiles': 'Recent Files',
        'endBtn': 'End Meeting',
        'endAlertTittle': "Are you sure to end the meeting?",
        'endAlertCancelBtn': "Cancel",
        'endAlertOkBtn': "Okay",
        'enterDiag': 'Enter a Diagnosis',
        'enterMedicine': 'Enter a Medicine',
        'camera': 'Camera',
        'gallery': 'Gallery',
        'diagnoseRequired': 'Diagnose Required',
        'medicineRequired': 'Medicine Required'
      };

  @override
  Map get doctorProfile => {
        'ifoTap': 'Information',
        'previousTap': 'Previous',
        'infoTapAbout': 'About',
        'prevTapMoreBtn': 'Show More',
        'editProfile': {
          'editTittle': 'Update Information',
          'phoneLabel': 'Phone',
          'phoneHint': 'enter your phone',
          'email': 'Email Address',
          'emailHint': 'enter your email',
          'name': 'Name',
          'nameHint': 'enter your name',
          'clinicAddressLabel': 'clinic Address',
          'clinicAddressHint': 'enter your clinic address',
          'saveBtn': 'Save',
          'cancelBtn': 'Cancel',
          'about': 'About',
          'aboutHint': 'enter information about you',
          'noPreviousAppointments':'No Previous Appointments',
          'no appointments':'No Appointments Yet ',
          'noTodayAppointments':'No Appointments Today'
        }
      };
  @override
  List get modelsDetails => [
    {
      'name': 'Covid19 Model',
      'modelName': 'covid19',
      'note': [
        'Model accuracy 90%',
        'It illustrates your disease from 3 diseases:'
      ],
      'diseases': ['Covid19', 'Viral Pneumonia', 'Normal']
    },
    {
      'name': 'Brain Tumor Model',
      'modelName': 'brain',
      'note': [
        'Model accuracy 90%',
        'It illustrates your disease from 3 diseases:'
      ],
      'diseases': ['Glioma', 'Meningioma', 'Pituitary']
    },
  ];

  @override
  String get closeBTN =>  'Close';
  @override
  String get explainText =>  'Explain';

  @override
  // TODO: implement endBTN
  String get endBTN => throw UnimplementedError();
}
