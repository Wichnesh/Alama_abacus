//const BaseUrl = "http://62.72.58.183:3500/api/";
// const BaseUrl ="http://62.72.58.183:3500/api/v1/"; //live
const BaseUrl ="http://localhost:3500/api/v1/"; //live
//const BaseUrl ="http://62.72.58.183:3501/api/v1/"; //test
const loginUrl = "${BaseUrl}login";
const generateIDUrl = "${BaseUrl}generateID";
const regfrachaniseUrl = "${BaseUrl}franchise-reg";
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
const getFilterTransactionUrl = "${BaseUrl}getFilterTransaction";
const getallorders = "${BaseUrl}getallorders";
const getallreports = "${BaseUrl}data";
const deleteCart = "${BaseUrl}studentcart-delete";
const tnReport = "${BaseUrl}tamilnadureport";


//2 to 3 , 5 to 6 AA
//2 to 3 , 4 to 5 , 5 to 6 MA
//item -- CB 1 Book ,PB 1 Book , Listen Ability, Speed Writing, Student Abacus , student bag , pencil,t-strit