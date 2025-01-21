const String dev = "dev";
const String prod = "prod";
const String local = "local";

// const String env = local;
const String env = "prod";
//const String env = "dev";

const String localUrl = "http://localhost:3500/api/v1/";
const String devUrl = "http://62.72.58.183:3501/api/v2/";
const String prodUrl = "http://185.75.21.53:3500/api/v2/";

const String BaseUrl = env == prod
    ? prodUrl
    : env == dev
        ? devUrl
        : localUrl;
const loginUrl = "${BaseUrl}login";
const generateIDUrl = "${BaseUrl}generateID";
const regfrachaniseUrl = "${BaseUrl}franchise-reg";
const loginStatusUrl = "${BaseUrl}login-status";
const getallfranchiseUrl = "${BaseUrl}getallfranchise";
const approveUserUrl = "${BaseUrl}approveUser";
const rejectUserUrl = "${BaseUrl}rejectUser";
const generateStudentIDUrl = "${BaseUrl}generate-studentid";
const studentregistrationUrl = "${BaseUrl}student-reg";
String studentUpdateUrl(String studentId) => "${BaseUrl}student-update/$studentId";
const studentcartregUrl = "${BaseUrl}studentcartreg";
const multiplestudentsUrl = "${BaseUrl}multiplestudents";
const getallstudentsUrl = "${BaseUrl}getallstudents";
const getcartstudents = "${BaseUrl}getcartstudents";
const getfranchisestudentUrl = "${BaseUrl}getfranchisestudent";
const getallitemsUrl = "${BaseUrl}getallitems";
const editItemUrl = "${BaseUrl}editItem";
const getitemtransactionUrl = "${BaseUrl}getitemtransaction";
const getallordersUrl = "${BaseUrl}order";
const createOrderordersUrl = "${BaseUrl}create-order";
const getFilterTransactionUrl = "${BaseUrl}getFilterTransaction";
const getallorders = "${BaseUrl}getallorders";
const getallreports = "${BaseUrl}data";
const deleteCart = "${BaseUrl}studentcart-delete";
const tnReport = "${BaseUrl}tamilnadureport";

class RazorPay {
  //static const key = "rzp_test_edocUhj72yJ1Rm";
  static const key = "rzp_live_AbmoGrxyMh5jnn";
  static const createOrder = "https://api.razorpay.com/v1/orders";
}

//2 to 3 , 5 to 6 AA
//2 to 3 , 4 to 5 , 5 to 6 MA
//item -- CB 1 Book ,PB 1 Book , Listen Ability, Speed Writing, Student Abacus , student bag , pencil,t-strit
