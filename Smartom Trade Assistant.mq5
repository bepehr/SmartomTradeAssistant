//+------------------------------------------------------------------------------+//
//)   ____  _  _  ____  ____  ____  ____  __  __    __      ___  _____  __  __   (//
//)  ( ___)( \/ )(  _ \(  _ \( ___)( ___)(  \/  )  /__\    / __)(  _  )(  \/  )  (//
//)   )__)  )  (  )(_) ))   / )__)  )__)  )    (  /(__)\  ( (__  )(_)(  )    (   (//
//)  (__)  (_/\_)(____/(_)\_)(____)(____)(_/\/\_)(__)(__)()\___)(_____)(_/\/\_)  (//
//)   https://fxdreema.com                             Copyright 2024, fxDreema  (//
//+------------------------------------------------------------------------------+//
#property copyright   ""
#property link        "https://github.com/bepehr/SmartomTradeAssistant"
#property description "This EA is free to use and it's always in the development stage , so please feel free to report any bugs on GitHub page \r\n\r\nIMPORTANT message : Because of varying contract size on some of indices like US30 or NDX100 with some brokers you should first check your stop loss amount with creating a test pending order with your broker \r\n"
#property version     "1.16"
#property strict

/************************************************************************************************************************/
// +------------------------------------------------------------------------------------------------------------------+ //
// |                       INPUT PARAMETERS, GLOBAL VARIABLES, CONSTANTS, IMPORTS and INCLUDES                        | //
// |                      System and Custom variables and other definitions used in the project                       | //
// +------------------------------------------------------------------------------------------------------------------+ //
/************************************************************************************************************************/

//VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV//
// System constants (project settings) //
//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^//
//--
#define PROJECT_ID "mt5-7990"
//--
// Point Format Rules
#define POINT_FORMAT_RULES "0.001=0.01,0.00001=0.0001,0.000001=0.0001" // this is deserialized in a special function later
#define ENABLE_SPREAD_METER false
#define ENABLE_STATUS false
#define ENABLE_TEST_INDICATORS false
//--
// Events On/Off
#define ENABLE_EVENT_TICK 1 // enable "Tick" event
#define ENABLE_EVENT_TRADE 1 // enable "Trade" event
#define ENABLE_EVENT_TIMER 0 // enable "Timer" event
//--
// Virtual Stops
#define VIRTUAL_STOPS_ENABLED 0 // enable virtual stops
#define VIRTUAL_STOPS_TIMEOUT 0 // virtual stops timeout
#define USE_EMERGENCY_STOPS "no" // "yes" to use emergency (hard stops) when virtual stops are in use. "always" to use EMERGENCY_STOPS_ADD as emergency stops when there is no virtual stop.
#define EMERGENCY_STOPS_REL 0 // use 0 to disable hard stops when virtual stops are enabled. Use a value >=0 to automatically set hard stops with virtual. Example: if 2 is used, then hard stops will be 2 times bigger than virtual ones.
#define EMERGENCY_STOPS_ADD 0 // add pips to relative size of emergency stops (hard stops)
//--
// Settings for events
#define ON_TIMER_PERIOD 60 // Timer event period (in seconds)

//VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV//
// System constants (predefined constants) //
//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^//
//--
#define TLOBJPROP_TIME1 801
#define OBJPROP_TL_PRICE_BY_SHIFT 802
#define OBJPROP_TL_SHIFT_BY_PRICE 803
#define OBJPROP_FIBOVALUE 804
#define OBJPROP_FIBOPRICEVALUE 805
#define OBJPROP_FIRSTLEVEL 806
#define OBJPROP_TIME1 807
#define OBJPROP_TIME2 808
#define OBJPROP_TIME3 809
#define OBJPROP_PRICE1 810
#define OBJPROP_PRICE2 811
#define OBJPROP_PRICE3 812
#define OBJPROP_BARSHIFT1 813
#define OBJPROP_BARSHIFT2 814
#define OBJPROP_BARSHIFT3 815
#define SEL_CURRENT 0
#define SEL_INITIAL 1

//VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV//
// Enumerations, Imports, Constants, Variables //
//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^//






//--
// Constants (Input Parameters)
input double Risk_Percent = 1.0; // Risk Percent
input double Maximum_Lot = 10.0; // Maximum Lot Size
input double Maximum_Margin_Percent = 60; //Maximum account margin to use
input int Close_Custom_Percent = 25; // % of position to close on Close Custom Button
input int TP1_Percent = 50; // Take profit 1 partial close percent
input int TP2_Percent = 50; // Take profit 2 partial close percent
input int TP3_Percent = 0; // Take profit 3 partial close percent
input int TP4_Percent = 0; // Take profit 4 partial close percent
input int TP5_Percent = 0; // Take profit 5 partial close percent
input bool Risk_Free_At_Auto_BE = true; // Also risk free when Auto break even hits
input bool Send_Phone_Notification = false; // Send phone notification
input color TP_Line_Color = Green; // TP price Line Color
input color Pending_Line_Color = Orange; // Pending Order price Line Color
input color SL_Line_Color = Red; // SL price line Color
input color Partial_TP_Line_Color = 0xFF00FF; // Partial TP lines color
input color BE_Triger_Line_Color = 0x07C1FF; // Break even trigger line color
input color BE_Target_Line_Color = 0xF0CA0D; // Break even target line color
input int MagicStart = 7990; // Magic Number, kind of...
class c
{
		public:
	static double Risk_Percent;
	static double Maximum_Lot;
	static double Maximum_Margin_Percent;
	static int Close_Custom_Percent;
	static int TP1_Percent;
	static int TP2_Percent;
	static int TP3_Percent;
	static int TP4_Percent;
	static int TP5_Percent;
	static bool Risk_Free_At_Auto_BE;
	static bool Send_Phone_Notification;
	static color TP_Line_Color;
	static color Pending_Line_Color;
	static color SL_Line_Color;
	static color Partial_TP_Line_Color;
	static color BE_Triger_Line_Color;
	static color BE_Target_Line_Color;
	static int MagicStart;
};
double c::Risk_Percent;
double c::Maximum_Lot;
double c::Maximum_Margin_Percent;
int c::Close_Custom_Percent;
int c::TP1_Percent;
int c::TP2_Percent;
int c::TP3_Percent;
int c::TP4_Percent;
int c::TP5_Percent;
bool c::Risk_Free_At_Auto_BE;
bool c::Send_Phone_Notification;
color c::TP_Line_Color;
color c::Pending_Line_Color;
color c::SL_Line_Color;
color c::Partial_TP_Line_Color;
color c::BE_Triger_Line_Color;
color c::BE_Target_Line_Color;
int c::MagicStart;


//--
// Variables (Global Variables)


































class v
{
		public:
	static double sl_price;
	static double tp_price;
	static double pending_order_price;
	static string sl_label_text;
	static string tp_label_text;
	static string pending_label_text;
	static bool pending_order;
	static double sl_distance_pip;
	static double tp_distance_pip;
	static double pending_distance_pip;
	static int pip_multiper;
	static bool cal_is_open;
	static double pip_value;
	static double money_for_risk;
	static double money_at_risk;
	static double calculated_volume;
	static string position_comment;
	static double risk_percent;
	static double rf_div;
	static bool auto_be_is_open;
	static double be_triger_price;
	static double be_target_price;
	static bool sl_moved_to_be_target;
	static bool partial_tp_is_open;
	static double tp1_price;
	static double tp2_price;
	static double tp3_price;
	static double tp4_price;
	static double tp5_price;
	static double t_high;
	static double t_low;
	static double pip_test;
	static double risk_percent_factor;
	static double correct_risk_percent;
};
double v::sl_price;
double v::tp_price;
double v::pending_order_price;
string v::sl_label_text;
string v::tp_label_text;
string v::pending_label_text;
bool v::pending_order;
double v::sl_distance_pip;
double v::tp_distance_pip;
double v::pending_distance_pip;
int v::pip_multiper;
bool v::cal_is_open;
double v::pip_value;
double v::money_for_risk;
double v::money_at_risk;
double v::calculated_volume;
string v::position_comment;
double v::risk_percent;
double v::rf_div;
bool v::auto_be_is_open;
double v::be_triger_price;
double v::be_target_price;
bool v::sl_moved_to_be_target;
bool v::partial_tp_is_open;
double v::tp1_price;
double v::tp2_price;
double v::tp3_price;
double v::tp4_price;
double v::tp5_price;
double v::t_high;
double v::t_low;
double v::pip_test;
double v::risk_percent_factor;
double v::correct_risk_percent;




//VVVVVVVVVVVVVVVVVVVVVVVVV//
// System global variables //
//^^^^^^^^^^^^^^^^^^^^^^^^^//
//--
// Blocks Lookup Functions
string fxdBlocksLookupTable[];

int FXD_CURRENT_FUNCTION_ID = 0;
double FXD_MILS_INIT_END    = 0;
int FXD_TICKS_FROM_START    = 0;
int FXD_MORE_SHIFT          = 0;
bool FXD_DRAW_SPREAD_INFO   = false;
bool FXD_FIRST_TICK_PASSED  = false;
bool FXD_BREAK              = false;
bool FXD_CONTINUE           = false;
bool USE_VIRTUAL_STOPS = VIRTUAL_STOPS_ENABLED;
string FXD_CURRENT_SYMBOL   = "";
int FXD_BLOCKS_COUNT        = 317;
datetime FXD_TICKSKIP_UNTIL = 0;

int FXD_ICUSTOM_HANDLES_IDS[]; // only used in MQL5
string FXD_ICUSTOM_HANDLES_KEYS[]; // only used in MQL5

//- for use in OnChart() event
struct fxd_onchart
{
	int id;
	long lparam;
	double dparam;
	string sparam;
};
fxd_onchart FXD_ONCHART;

/************************************************************************************************************************/
// +------------------------------------------------------------------------------------------------------------------+ //
// |                                                 EVENT FUNCTIONS                                                  | //
// |                           These are the main functions that controls the whole project                           | //
// +------------------------------------------------------------------------------------------------------------------+ //
/************************************************************************************************************************/

//VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV//
// This function is executed once when the program starts //
//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^//
int OnInit()
{

	// Initiate Constants
	c::Risk_Percent = Risk_Percent;
	c::Maximum_Lot = Maximum_Lot;
	c::Maximum_Margin_Percent = Maximum_Margin_Percent;
	c::Close_Custom_Percent = Close_Custom_Percent;
	c::TP1_Percent = TP1_Percent;
	c::TP2_Percent = TP2_Percent;
	c::TP3_Percent = TP3_Percent;
	c::TP4_Percent = TP4_Percent;
	c::TP5_Percent = TP5_Percent;
	c::Risk_Free_At_Auto_BE = Risk_Free_At_Auto_BE;
	c::Send_Phone_Notification = Send_Phone_Notification;
	c::TP_Line_Color = TP_Line_Color;
	c::Pending_Line_Color = Pending_Line_Color;
	c::SL_Line_Color = SL_Line_Color;
	c::Partial_TP_Line_Color = Partial_TP_Line_Color;
	c::BE_Triger_Line_Color = BE_Triger_Line_Color;
	c::BE_Target_Line_Color = BE_Target_Line_Color;
	c::MagicStart = MagicStart;




	// do or do not not initilialize on reload
	if (UninitializeReason() != 0)
	{
		if (UninitializeReason() == REASON_CHARTCHANGE)
		{
			// if the symbol is the same, do not reload, otherwise continue below
			if (FXD_CURRENT_SYMBOL == Symbol()) {return INIT_SUCCEEDED;}
		}
		else
		{
			return INIT_SUCCEEDED;
		}
	}
	FXD_CURRENT_SYMBOL = Symbol();

	CurrentSymbol(FXD_CURRENT_SYMBOL); // CurrentSymbol() has internal memory that should be set from here when the symboll is changed
	CurrentTimeframe(PERIOD_CURRENT);

	v::sl_price = 0.0;
	v::tp_price = 0.0;
	v::pending_order_price = 0.0;
	v::sl_label_text = "";
	v::tp_label_text = "";
	v::pending_label_text = "";
	v::pending_order = 0;
	v::sl_distance_pip = 0.0;
	v::tp_distance_pip = 0.0;
	v::pending_distance_pip = 0.0;
	v::pip_multiper = 0;
	v::cal_is_open = 0;
	v::pip_value = 0.0;
	v::money_for_risk = 0.0;
	v::money_at_risk = 0.0;
	v::calculated_volume = 0.0;
	v::position_comment = "";
	v::risk_percent = 0.0;
	v::rf_div = 0.0;
	v::auto_be_is_open = 0;
	v::be_triger_price = 0.0;
	v::be_target_price = 0.0;
	v::sl_moved_to_be_target = 0;
	v::partial_tp_is_open = 0;
	v::tp1_price = 0.0;
	v::tp2_price = 0.0;
	v::tp3_price = 0.0;
	v::tp4_price = 0.0;
	v::tp5_price = 0.0;
	v::t_high = 0.0;
	v::t_low = 0.0;
	v::pip_test = 0.0;
	v::risk_percent_factor = 1.0;
	v::correct_risk_percent = 0.0;




	Comment("");
	for (int i=ObjectsTotal(ChartID()); i>=0; i--)
	{
		string name = ObjectName(ChartID(), i);
		if (StringSubstr(name,0,8) == "fxd_cmnt") {ObjectDelete(ChartID(), name);}
	}
	ChartRedraw();



	//-- disable virtual stops in optimization, because graphical objects does not work
	// http://docs.mql4.com/runtime/testing
	if (MQLInfoInteger(MQL_OPTIMIZATION)) {
		USE_VIRTUAL_STOPS = false;
	}

	//-- set initial local and server time
	TimeAtStart("set");

	//-- set initial balance
	AccountBalanceAtStart();

	//-- draw the initial spread info meter
	if (ENABLE_SPREAD_METER == false) {
		FXD_DRAW_SPREAD_INFO = false;
	}
	else {
		FXD_DRAW_SPREAD_INFO = !(MQLInfoInteger(MQL_TESTER) && !MQLInfoInteger(MQL_VISUAL_MODE));
	}
	if (FXD_DRAW_SPREAD_INFO) DrawSpreadInfo();

	//-- draw initial status
	if (ENABLE_STATUS) DrawStatus("waiting for tick...");

	//-- draw indicators after test
	TesterHideIndicators(!ENABLE_TEST_INDICATORS);

	if (ENABLE_EVENT_TIMER) {
		OnTimerSet(ON_TIMER_PERIOD);
	}


	//-- Initialize blocks classes
	ArrayResize(_blocks_, 317);

	_blocks_[0] = new Block0();
	_blocks_[1] = new Block1();
	_blocks_[2] = new Block2();
	_blocks_[3] = new Block3();
	_blocks_[4] = new Block4();
	_blocks_[5] = new Block5();
	_blocks_[6] = new Block6();
	_blocks_[7] = new Block7();
	_blocks_[8] = new Block8();
	_blocks_[9] = new Block9();
	_blocks_[10] = new Block10();
	_blocks_[11] = new Block11();
	_blocks_[12] = new Block12();
	_blocks_[13] = new Block13();
	_blocks_[14] = new Block14();
	_blocks_[15] = new Block15();
	_blocks_[16] = new Block16();
	_blocks_[17] = new Block17();
	_blocks_[18] = new Block18();
	_blocks_[19] = new Block19();
	_blocks_[20] = new Block20();
	_blocks_[21] = new Block21();
	_blocks_[22] = new Block22();
	_blocks_[23] = new Block23();
	_blocks_[24] = new Block24();
	_blocks_[25] = new Block25();
	_blocks_[26] = new Block26();
	_blocks_[27] = new Block27();
	_blocks_[28] = new Block28();
	_blocks_[29] = new Block29();
	_blocks_[30] = new Block30();
	_blocks_[31] = new Block31();
	_blocks_[32] = new Block32();
	_blocks_[33] = new Block33();
	_blocks_[34] = new Block34();
	_blocks_[35] = new Block35();
	_blocks_[36] = new Block36();
	_blocks_[37] = new Block37();
	_blocks_[38] = new Block38();
	_blocks_[39] = new Block39();
	_blocks_[40] = new Block40();
	_blocks_[41] = new Block41();
	_blocks_[42] = new Block42();
	_blocks_[43] = new Block43();
	_blocks_[44] = new Block44();
	_blocks_[45] = new Block45();
	_blocks_[46] = new Block46();
	_blocks_[47] = new Block47();
	_blocks_[48] = new Block48();
	_blocks_[49] = new Block49();
	_blocks_[50] = new Block50();
	_blocks_[51] = new Block51();
	_blocks_[52] = new Block52();
	_blocks_[53] = new Block53();
	_blocks_[54] = new Block54();
	_blocks_[55] = new Block55();
	_blocks_[56] = new Block56();
	_blocks_[57] = new Block57();
	_blocks_[58] = new Block58();
	_blocks_[59] = new Block59();
	_blocks_[60] = new Block60();
	_blocks_[61] = new Block61();
	_blocks_[62] = new Block62();
	_blocks_[63] = new Block63();
	_blocks_[64] = new Block64();
	_blocks_[65] = new Block65();
	_blocks_[66] = new Block66();
	_blocks_[67] = new Block67();
	_blocks_[68] = new Block68();
	_blocks_[69] = new Block69();
	_blocks_[70] = new Block70();
	_blocks_[71] = new Block71();
	_blocks_[72] = new Block72();
	_blocks_[73] = new Block73();
	_blocks_[74] = new Block74();
	_blocks_[75] = new Block75();
	_blocks_[76] = new Block76();
	_blocks_[77] = new Block77();
	_blocks_[78] = new Block78();
	_blocks_[79] = new Block79();
	_blocks_[80] = new Block80();
	_blocks_[81] = new Block81();
	_blocks_[82] = new Block82();
	_blocks_[83] = new Block83();
	_blocks_[84] = new Block84();
	_blocks_[85] = new Block85();
	_blocks_[86] = new Block86();
	_blocks_[87] = new Block87();
	_blocks_[88] = new Block88();
	_blocks_[89] = new Block89();
	_blocks_[90] = new Block90();
	_blocks_[91] = new Block91();
	_blocks_[92] = new Block92();
	_blocks_[93] = new Block93();
	_blocks_[94] = new Block94();
	_blocks_[95] = new Block95();
	_blocks_[96] = new Block96();
	_blocks_[97] = new Block97();
	_blocks_[98] = new Block98();
	_blocks_[99] = new Block99();
	_blocks_[100] = new Block100();
	_blocks_[101] = new Block101();
	_blocks_[102] = new Block102();
	_blocks_[103] = new Block103();
	_blocks_[104] = new Block104();
	_blocks_[105] = new Block105();
	_blocks_[106] = new Block106();
	_blocks_[107] = new Block107();
	_blocks_[108] = new Block108();
	_blocks_[109] = new Block109();
	_blocks_[110] = new Block110();
	_blocks_[111] = new Block111();
	_blocks_[112] = new Block112();
	_blocks_[113] = new Block113();
	_blocks_[114] = new Block114();
	_blocks_[115] = new Block115();
	_blocks_[116] = new Block116();
	_blocks_[117] = new Block117();
	_blocks_[118] = new Block118();
	_blocks_[119] = new Block119();
	_blocks_[120] = new Block120();
	_blocks_[121] = new Block121();
	_blocks_[122] = new Block122();
	_blocks_[123] = new Block123();
	_blocks_[124] = new Block124();
	_blocks_[125] = new Block125();
	_blocks_[126] = new Block126();
	_blocks_[127] = new Block127();
	_blocks_[128] = new Block128();
	_blocks_[129] = new Block129();
	_blocks_[130] = new Block130();
	_blocks_[131] = new Block131();
	_blocks_[132] = new Block132();
	_blocks_[133] = new Block133();
	_blocks_[134] = new Block134();
	_blocks_[135] = new Block135();
	_blocks_[136] = new Block136();
	_blocks_[137] = new Block137();
	_blocks_[138] = new Block138();
	_blocks_[139] = new Block139();
	_blocks_[140] = new Block140();
	_blocks_[141] = new Block141();
	_blocks_[142] = new Block142();
	_blocks_[143] = new Block143();
	_blocks_[144] = new Block144();
	_blocks_[145] = new Block145();
	_blocks_[146] = new Block146();
	_blocks_[147] = new Block147();
	_blocks_[148] = new Block148();
	_blocks_[149] = new Block149();
	_blocks_[150] = new Block150();
	_blocks_[151] = new Block151();
	_blocks_[152] = new Block152();
	_blocks_[153] = new Block153();
	_blocks_[154] = new Block154();
	_blocks_[155] = new Block155();
	_blocks_[156] = new Block156();
	_blocks_[157] = new Block157();
	_blocks_[158] = new Block158();
	_blocks_[159] = new Block159();
	_blocks_[160] = new Block160();
	_blocks_[161] = new Block161();
	_blocks_[162] = new Block162();
	_blocks_[163] = new Block163();
	_blocks_[164] = new Block164();
	_blocks_[165] = new Block165();
	_blocks_[166] = new Block166();
	_blocks_[167] = new Block167();
	_blocks_[168] = new Block168();
	_blocks_[169] = new Block169();
	_blocks_[170] = new Block170();
	_blocks_[171] = new Block171();
	_blocks_[172] = new Block172();
	_blocks_[173] = new Block173();
	_blocks_[174] = new Block174();
	_blocks_[175] = new Block175();
	_blocks_[176] = new Block176();
	_blocks_[177] = new Block177();
	_blocks_[178] = new Block178();
	_blocks_[179] = new Block179();
	_blocks_[180] = new Block180();
	_blocks_[181] = new Block181();
	_blocks_[182] = new Block182();
	_blocks_[183] = new Block183();
	_blocks_[184] = new Block184();
	_blocks_[185] = new Block185();
	_blocks_[186] = new Block186();
	_blocks_[187] = new Block187();
	_blocks_[188] = new Block188();
	_blocks_[189] = new Block189();
	_blocks_[190] = new Block190();
	_blocks_[191] = new Block191();
	_blocks_[192] = new Block192();
	_blocks_[193] = new Block193();
	_blocks_[194] = new Block194();
	_blocks_[195] = new Block195();
	_blocks_[196] = new Block196();
	_blocks_[197] = new Block197();
	_blocks_[198] = new Block198();
	_blocks_[199] = new Block199();
	_blocks_[200] = new Block200();
	_blocks_[201] = new Block201();
	_blocks_[202] = new Block202();
	_blocks_[203] = new Block203();
	_blocks_[204] = new Block204();
	_blocks_[205] = new Block205();
	_blocks_[206] = new Block206();
	_blocks_[207] = new Block207();
	_blocks_[208] = new Block208();
	_blocks_[209] = new Block209();
	_blocks_[210] = new Block210();
	_blocks_[211] = new Block211();
	_blocks_[212] = new Block212();
	_blocks_[213] = new Block213();
	_blocks_[214] = new Block214();
	_blocks_[215] = new Block215();
	_blocks_[216] = new Block216();
	_blocks_[217] = new Block217();
	_blocks_[218] = new Block218();
	_blocks_[219] = new Block219();
	_blocks_[220] = new Block220();
	_blocks_[221] = new Block221();
	_blocks_[222] = new Block222();
	_blocks_[223] = new Block223();
	_blocks_[224] = new Block224();
	_blocks_[225] = new Block225();
	_blocks_[226] = new Block226();
	_blocks_[227] = new Block227();
	_blocks_[228] = new Block228();
	_blocks_[229] = new Block229();
	_blocks_[230] = new Block230();
	_blocks_[231] = new Block231();
	_blocks_[232] = new Block232();
	_blocks_[233] = new Block233();
	_blocks_[234] = new Block234();
	_blocks_[235] = new Block235();
	_blocks_[236] = new Block236();
	_blocks_[237] = new Block237();
	_blocks_[238] = new Block238();
	_blocks_[239] = new Block239();
	_blocks_[240] = new Block240();
	_blocks_[241] = new Block241();
	_blocks_[242] = new Block242();
	_blocks_[243] = new Block243();
	_blocks_[244] = new Block244();
	_blocks_[245] = new Block245();
	_blocks_[246] = new Block246();
	_blocks_[247] = new Block247();
	_blocks_[248] = new Block248();
	_blocks_[249] = new Block249();
	_blocks_[250] = new Block250();
	_blocks_[251] = new Block251();
	_blocks_[252] = new Block252();
	_blocks_[253] = new Block253();
	_blocks_[254] = new Block254();
	_blocks_[255] = new Block255();
	_blocks_[256] = new Block256();
	_blocks_[257] = new Block257();
	_blocks_[258] = new Block258();
	_blocks_[259] = new Block259();
	_blocks_[260] = new Block260();
	_blocks_[261] = new Block261();
	_blocks_[262] = new Block262();
	_blocks_[263] = new Block263();
	_blocks_[264] = new Block264();
	_blocks_[265] = new Block265();
	_blocks_[266] = new Block266();
	_blocks_[267] = new Block267();
	_blocks_[268] = new Block268();
	_blocks_[269] = new Block269();
	_blocks_[270] = new Block270();
	_blocks_[271] = new Block271();
	_blocks_[272] = new Block272();
	_blocks_[273] = new Block273();
	_blocks_[274] = new Block274();
	_blocks_[275] = new Block275();
	_blocks_[276] = new Block276();
	_blocks_[277] = new Block277();
	_blocks_[278] = new Block278();
	_blocks_[279] = new Block279();
	_blocks_[280] = new Block280();
	_blocks_[281] = new Block281();
	_blocks_[282] = new Block282();
	_blocks_[283] = new Block283();
	_blocks_[284] = new Block284();
	_blocks_[285] = new Block285();
	_blocks_[286] = new Block286();
	_blocks_[287] = new Block287();
	_blocks_[288] = new Block288();
	_blocks_[289] = new Block289();
	_blocks_[290] = new Block290();
	_blocks_[291] = new Block291();
	_blocks_[292] = new Block292();
	_blocks_[293] = new Block293();
	_blocks_[294] = new Block294();
	_blocks_[295] = new Block295();
	_blocks_[296] = new Block296();
	_blocks_[297] = new Block297();
	_blocks_[298] = new Block298();
	_blocks_[299] = new Block299();
	_blocks_[300] = new Block300();
	_blocks_[301] = new Block301();
	_blocks_[302] = new Block302();
	_blocks_[303] = new Block303();
	_blocks_[304] = new Block304();
	_blocks_[305] = new Block305();
	_blocks_[306] = new Block306();
	_blocks_[307] = new Block307();
	_blocks_[308] = new Block308();
	_blocks_[309] = new Block309();
	_blocks_[310] = new Block310();
	_blocks_[311] = new Block311();
	_blocks_[312] = new Block312();
	_blocks_[313] = new Block313();
	_blocks_[314] = new Block314();
	_blocks_[315] = new Block315();
	_blocks_[316] = new Block316();

	// fill the lookup table
	ArrayResize(fxdBlocksLookupTable, ArraySize(_blocks_));
	for (int i=0; i<ArraySize(_blocks_); i++)
	{
		fxdBlocksLookupTable[i] = _blocks_[i].__block_user_number;
	}

	// fill the list of inbound blocks for each BlockCalls instance
	for (int i=0; i<ArraySize(_blocks_); i++)
	{
		_blocks_[i].__announceThisBlock();
	}

	// List of initially disabled blocks
	int disabled_blocks_list[] = {19,111,112,113,114,115,116,117,118,119,120};
	for (int l = 0; l < ArraySize(disabled_blocks_list); l++) {
		_blocks_[disabled_blocks_list[l]].__disabled = true;
	}

	//-- run blocks
	int blocks_to_run[] = {18,301};
	for (int i=0; i<ArraySize(blocks_to_run); i++) {
		_blocks_[blocks_to_run[i]].run();
	}


	FXD_MILS_INIT_END     = (double)GetTickCount();
	FXD_FIRST_TICK_PASSED = false; // reset is needed when changing inputs

	return(INIT_SUCCEEDED);
}

//VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV//
// This function is executed on every incoming tick //
//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^//
void OnTick()
{
	FXD_TICKS_FROM_START++;

	if (ENABLE_STATUS && FXD_TICKS_FROM_START == 1) DrawStatus("working");

	//-- special system actions
	if (FXD_DRAW_SPREAD_INFO) DrawSpreadInfo();
	TicksData(""); // Collect ticks (if needed)
	TicksPerSecond(false, true); // Collect ticks per second
	if (USE_VIRTUAL_STOPS) {VirtualStopsDriver();}

	if (false) ExpirationWorker * expirationDummy = new ExpirationWorker();
	expirationWorker.Run();

	OCODriver(); // Check and close OCO orders

	// skip ticks
	if (TimeLocal() < FXD_TICKSKIP_UNTIL) {return;}

	//-- run blocks
	int blocks_to_run[] = {108,195};
	for (int i=0; i<ArraySize(blocks_to_run); i++) {
		_blocks_[blocks_to_run[i]].run();
	}


	return;
}

//VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV//
// This function is executed on trade events - open, close, modify //
//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^//
void OnTrade()
{
	// This is needed so that the OnTradeEventDetector class is added into the code
	if (false) OnTradeEventDetector * dummy = new OnTradeEventDetector();

	while (onTradeEventDetector.Start() == true)
	{
	//-- run blocks
	int blocks_to_run[] = {236};
	for (int i=0; i<ArraySize(blocks_to_run); i++) {
		_blocks_[blocks_to_run[i]].run();
	}

	}

	onTradeEventDetector.End();

}


//VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV//
// This function is executed on a period basis //
//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^//
void OnTimer()
{

}


//VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV//
// This function is executed when chart event happens //
//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^//
void OnChartEvent(
	const int id,         // Event ID
	const long& lparam,   // Parameter of type long event
	const double& dparam, // Parameter of type double event
	const string& sparam  // Parameter of type string events
)
{
	//-- write parameter to the system global variables
	FXD_ONCHART.id     = id;
	FXD_ONCHART.lparam = lparam;
	FXD_ONCHART.dparam = dparam;
	FXD_ONCHART.sparam = sparam;

	//-- run blocks
	int blocks_to_run[] = {0,1,3,6,10,36,39,72,74,78,84,86,89,91,95,104,106,109,112,118,132,157,178,180,182,184,186,188,277};
	for (int i=0; i<ArraySize(blocks_to_run); i++) {
		_blocks_[blocks_to_run[i]].run();
	}

	return;
}

//VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV//
// This function is executed once when the program ends //
//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^//
void OnDeinit(const int reason)
{
	int reson = UninitializeReason();
	if (reson == REASON_CHARTCHANGE || reson == REASON_PARAMETERS || reason == REASON_TEMPLATE || reason == REASON_ACCOUNT) {return;}

	//-- if Timer was set, kill it here
	EventKillTimer();

	if (ENABLE_STATUS) DrawStatus("stopped");
	if (ENABLE_SPREAD_METER) DrawSpreadInfo();
	ChartSetString(0, CHART_COMMENT, "");

	//-- run blocks
	int blocks_to_run[] = {55};
	for (int i=0; i<ArraySize(blocks_to_run); i++) {
		_blocks_[blocks_to_run[i]].run();
	}


	if (MQLInfoInteger(MQL_TESTER)) {
		Print("Backtested in "+DoubleToString((GetTickCount()-FXD_MILS_INIT_END)/1000, 2)+" seconds");
		double tc = GetTickCount()-FXD_MILS_INIT_END;
		if (tc > 0)
		{
			Print("Average ticks per second: "+DoubleToString(FXD_TICKS_FROM_START/tc, 0));
		}
	}

	if (MQLInfoInteger(MQL_PROGRAM_TYPE) == PROGRAM_EXPERT)
	{
		switch(UninitializeReason())
		{
			case REASON_PROGRAM		: Print("Expert Advisor self terminated"); break;
			case REASON_REMOVE		: Print("Expert Advisor removed from the chart"); break;
			case REASON_RECOMPILE	: Print("Expert Advisor has been recompiled"); break;
			case REASON_CHARTCHANGE	: Print("Symbol or chart period has been changed"); break;
			case REASON_CHARTCLOSE	: Print("Chart has been closed"); break;
			case REASON_PARAMETERS	: Print("Input parameters have been changed by a user"); break;
			case REASON_ACCOUNT		: Print("Another account has been activated or reconnection to the trade server has occurred due to changes in the account settings"); break;
			case REASON_TEMPLATE		: Print("A new template has been applied"); break;
			case REASON_INITFAILED	: Print("OnInit() handler has returned a nonzero value"); break;
			case REASON_CLOSE			: Print("Terminal has been closed"); break;
		}
	}

	// delete dynamic pointers
	for (int i=0; i<ArraySize(_blocks_); i++)
	{
		delete _blocks_[i];
		_blocks_[i] = NULL;
	}
	ArrayResize(_blocks_, 0);

	return;
}

/************************************************************************************************************************/
// +------------------------------------------------------------------------------------------------------------------+ //
// |                                             Classes of blocks                                                    | //
// |              Classes that contain the actual code of the blocks and their input parameters as well               | //
// +------------------------------------------------------------------------------------------------------------------+ //
/************************************************************************************************************************/

/**
	The base class for all block calls
   */
class BlockCalls
{
	public:
		bool __disabled; // whether or not the block is disabled

		string __block_user_number;
        int __block_number;
		int __block_waiting;
		int __parent_number;
		int __inbound_blocks[];
		int __outbound_blocks[];

		void __addInboundBlock(int id = 0) {
			int size = ArraySize(__inbound_blocks);
			for (int i = 0; i < size; i++) {
				if (__inbound_blocks[i] == id) {
					return;
				}
			}
			ArrayResize(__inbound_blocks, size + 1);
			__inbound_blocks[size] = id;
		}

		void BlockCalls() {
			__disabled          = false;
			__block_user_number = "";
			__block_number      = 0;
			__block_waiting     = 0;
			__parent_number     = 0;
		}

		/**
		   Announce this block to the list of inbound connections of all the blocks to which this block is connected to
		   */
		void __announceThisBlock()
		{
		   // add the current block number to the list of inbound blocks
		   // for each outbound block that is provided
			for (int i = 0; i < ArraySize(__outbound_blocks); i++)
			{
				int block = __outbound_blocks[i]; // outbound block number
				int size  = ArraySize(_blocks_[block].__inbound_blocks); // the size of its inbound list

				// skip if the current block was already added
				for (int j = 0; j < size; j++) {
					if (_blocks_[block].__inbound_blocks[j] == __block_number)
					{
						return;
					}
				}

				// add the current block number to the list of inbound blocks of the other block
				ArrayResize(_blocks_[block].__inbound_blocks, size + 1);
				_blocks_[block].__inbound_blocks[size] = __block_number;
			}
		}

		// this is here, because it is used in the "run" function
		virtual void _execute_() = 0;

		/**
			In the derived class this method should be used to set dynamic parameters or other stuff before the main execute.
			This method is automatically called within the main "run" method below, before the execution of the main class.
			*/
		virtual void _beforeExecute_() {return;};
		bool _beforeExecuteEnabled; // for speed

		/**
			Same as _beforeExecute_, but to work after the execute method.
			*/
		virtual void _afterExecute_() {return;};
		bool _afterExecuteEnabled; // for speed

		/**
			This is the method that is used to run the block
			*/
		virtual void run(int _parent_=0) {
			__parent_number = _parent_;
			if (__disabled || FXD_BREAK) {return;}
			FXD_CURRENT_FUNCTION_ID = __block_number;

			if (_beforeExecuteEnabled) {_beforeExecute_();}
			_execute_();
			if (_afterExecuteEnabled) {_afterExecute_();}

			if (__block_waiting && FXD_CURRENT_FUNCTION_ID == __block_number) {fxdWait.Accumulate(FXD_CURRENT_FUNCTION_ID);}
		}
};

BlockCalls *_blocks_[];


// "Mouse clicked on object" model
template<typename T1,typename T2>
class MDL_eChart_MouseClickObject: public BlockCalls
{
	public: /* Input Parameters */
	T1 NameFilterMode;
	T2 ObjName;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_eChart_MouseClickObject()
	{
		NameFilterMode = (string)"";
		ObjName = (string)"";
	}

	public: /* The main method */
	virtual void _execute_()
	{
		bool next = false;
		
		if (FXD_ONCHART.id == CHARTEVENT_OBJECT_CLICK)
		{
			if (NameFilterMode == "name" || NameFilterMode == "names")
			{
				string names[];
		
				if (ObjName != "")
				{
					StringExplode(",", ObjName, names);
					int size = ArraySize(names);
		
					for (int i = 0; i < size; i++)
					{
						if (FXD_ONCHART.sparam == StringTrim(names[i]))
						{
							next = true;
							break;
						}
					}
				}
			}
			else
			{
				next = true;
			}
		}
		
		if (next == true) {_callback_(1);} else {_callback_(0);}
	}
};

// "Draw Line" model
template<typename T1,typename T2,typename T3,typename T4,typename T5,typename _T5_,typename T6,typename _T6_,typename T7,typename _T7_,typename T8,typename _T8_,typename T9,typename T10,typename T11,typename T12,typename T13,typename T14,typename T15,typename T16,typename T17,typename T18,typename T19,typename T20,typename T21>
class MDL_ChartDrawLine: public BlockCalls
{
	public: /* Input Parameters */
	T1 ObjectPerBar;
	T2 ObjectUpdate;
	T3 ObjName;
	T4 ObjectType;
	T5 ObjTime1; virtual _T5_ _ObjTime1_(){return(_T5_)0;}
	T6 ObjPrice1; virtual _T6_ _ObjPrice1_(){return(_T6_)0;}
	T7 ObjTime2; virtual _T7_ _ObjTime2_(){return(_T7_)0;}
	T8 ObjPrice2; virtual _T8_ _ObjPrice2_(){return(_T8_)0;}
	T9 ObjAngle;
	T10 ObjRay;
	T11 ObjRayLeft;
	T12 ObjRayRight;
	T13 ObjColor;
	T14 ObjStyle;
	T15 ObjWidth;
	T16 ObjBack;
	T17 ObjSelectable;
	T18 ObjSelected;
	T19 ObjHidden;
	T20 ObjZorder;
	T21 ObjChartSubWindow;
	/* Static Parameters */
	int count;
	datetime time0;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_ChartDrawLine()
	{
		ObjectPerBar = (bool)true;
		ObjectUpdate = (bool)true;
		ObjName = (string)"";
		ObjectType = (ENUM_OBJECT)OBJ_VLINE;
		ObjAngle = (double)45.0;
		ObjRay = (bool)true;
		ObjRayLeft = (bool)false;
		ObjRayRight = (bool)false;
		ObjColor = (color)clrDeepPink;
		ObjStyle = (ENUM_LINE_STYLE)STYLE_SOLID;
		ObjWidth = (int)1;
		ObjBack = (bool)false;
		ObjSelectable = (bool)true;
		ObjSelected = (bool)false;
		ObjHidden = (bool)false;
		ObjZorder = (int)0;
		ObjChartSubWindow = (string)"";
		/* Static Parameters (initial value) */
		count =  0;
		time0 =  0;
	}

	public: /* The main method */
	virtual void _execute_()
	{
		string ObjNamePrefix = "fxd_line_";
		long ObjChartID      = 0;
		int subwindow_id     = WindowFindVisible(ObjChartID, ObjChartSubWindow);
		
		if (subwindow_id >= 0)
		{
			string name       = "";
			string name_base  = "";
			bool get_new_name = false;
			bool do_update    = true;
		
			if (ObjectPerBar == true)
			{
				datetime time = iTime(Symbol(),0,1);
		
				if (time0 < time)
				{
					time0        = time;
					get_new_name = true;
				}
				else
				{
					if (ObjectUpdate == false) {do_update = false;}
				}
			}
			else
			{
				if (ObjectUpdate == false) {get_new_name = true;}
			}
		
			if (do_update)
			{
				if (ObjName != "") {name_base = ObjName;} else {name_base = ObjNamePrefix + __block_user_number + "_";}
		
				if (get_new_name == false)
				{
					name = name_base + IntegerToString(count);
				}
				else
				{
					while (true)
					{
						count++;
						name = name_base + IntegerToString(count);
		
						if (ObjectFind(ObjChartID,name) < 0) {break;}
					}
				}
		
				if (ObjName != "" && count == 0) {name = ObjName;}
		
				if (ObjectFind(ObjChartID,name) < 0 && !ObjectCreate(ObjChartID,name,(ENUM_OBJECT)ObjectType,subwindow_id,0,0))
				{
					Print(__FUNCTION__,": failed to create line object! Error code = ",GetLastError());
				}
		
				double p1=0, p2=0;
				datetime t1=0, t2=0;
		
				switch(ObjectType)
				{
					case OBJ_VLINE        : {t1=1; break;}
					case OBJ_HLINE        : {p1=1; break;}
					case OBJ_TREND        : {t1=1; p1=1; t2=1; p2=1; break;}
					case OBJ_TRENDBYANGLE : {t1=1; p1=1; break;}
					case OBJ_CYCLES       : {t1=1; p1=1; t2=1; p2=1; break;}
				}
		
				if (t1 == 1) {t1 = _ObjTime1_(); ObjectSetInteger(ObjChartID,name,OBJPROP_TIME,0,t1);}
				if (t2 == 1) {t2 = _ObjTime2_(); ObjectSetInteger(ObjChartID,name,OBJPROP_TIME,1,t2);}
				if (p1 == 1) {p1 = _ObjPrice1_(); ObjectSetDouble(ObjChartID,name,OBJPROP_PRICE,0,p1);}
				if (p2 == 1) {p2 = _ObjPrice2_(); ObjectSetDouble(ObjChartID,name,OBJPROP_PRICE,1,p2);}
		
				ObjectSetInteger(ObjChartID,name,OBJPROP_STYLE,ObjStyle);
				ObjectSetInteger(ObjChartID,name,OBJPROP_COLOR,ObjColor);
				ObjectSetInteger(ObjChartID,name,OBJPROP_BACK,ObjBack);
				ObjectSetInteger(ObjChartID,name,OBJPROP_WIDTH,ObjWidth);
				ObjectSetInteger(ObjChartID,name,OBJPROP_SELECTABLE,ObjSelectable);
				ObjectSetInteger(ObjChartID,name,OBJPROP_SELECTED,ObjSelected);
				ObjectSetInteger(ObjChartID,name,OBJPROP_HIDDEN,ObjHidden);
				ObjectSetInteger(ObjChartID,name,OBJPROP_ZORDER,ObjZorder);
		
				ObjectSetDouble(ObjChartID,name,OBJPROP_ANGLE,ObjAngle);
				ObjectSetInteger(ObjChartID,name,OBJPROP_RAY,ObjRay);
				ObjectSetInteger(ObjChartID,name,OBJPROP_RAY_LEFT,ObjRayLeft);
				ObjectSetInteger(ObjChartID,name,OBJPROP_RAY_RIGHT,ObjRayRight);
		
				ChartRedraw();
			}
		}
		
		_callback_(1);
	}
};

// "Object dragged" model
template<typename T1,typename T2>
class MDL_eChart_ObjectDrag: public BlockCalls
{
	public: /* Input Parameters */
	T1 NameFilterMode;
	T2 ObjName;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_eChart_ObjectDrag()
	{
		NameFilterMode = (string)"";
		ObjName = (string)"";
	}

	public: /* The main method */
	virtual void _execute_()
	{
		bool next = false;
		
		if (FXD_ONCHART.id == CHARTEVENT_OBJECT_DRAG)
		{
			if (NameFilterMode == "name" || NameFilterMode == "names")
			{
				string names[];
		
				if (ObjName != "")
				{
					StringExplode(",", ObjName, names);
					int size = ArraySize(names);
		
					for (int i=0; i<size; i++)
					{
						if (FXD_ONCHART.sparam == StringTrim(names[i]))
						{
							next = true;
							break;
						}
					}
				}
			}
			else
			{
				next = true;
			}
		}
		
		if (next == true) {_callback_(1);} else {_callback_(0);}
	}
};

// "Modify Variables" model
template<typename T1,typename T2,typename _T2_,typename T3,typename T4,typename _T4_,typename T5,typename T6,typename _T6_,typename T7,typename T8,typename _T8_,typename T9,typename T10,typename _T10_>
class MDL_ModifyVariables: public BlockCalls
{
	public: /* Input Parameters */
	T1 Variable1;
	T2 Value1; virtual _T2_ _Value1_(){return(_T2_)0;}
	T3 Variable2;
	T4 Value2; virtual _T4_ _Value2_(){return(_T4_)0;}
	T5 Variable3;
	T6 Value3; virtual _T6_ _Value3_(){return(_T6_)0;}
	T7 Variable4;
	T8 Value4; virtual _T8_ _Value4_(){return(_T8_)0;}
	T9 Variable5;
	T10 Value5; virtual _T10_ _Value5_(){return(_T10_)0;}
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_ModifyVariables()
	{
		Variable1 = (int)0;
		Variable2 = (int)0;
		Variable3 = (int)0;
		Variable4 = (int)0;
		Variable5 = (int)0;
	}

	public: /* The main method */
	virtual void _execute_()
	{
		// nothing here, because the actual code is generated in the generator
		// _Value1_()
		// _Value2_()
		// _Value3_()
		// _Value4_()
		// _Value5_()
		_callback_(1);
	}
};

// "Draw Text" model
template<typename T1,typename T2,typename T3,typename T4,typename T5,typename _T5_,typename T6,typename _T6_,typename T7,typename T8,typename T9,typename _T9_,typename T10,typename T11,typename T12,typename T13,typename T14,typename T15,typename T16,typename T17,typename T18,typename T19,typename T20,typename T21>
class MDL_ChartDrawText: public BlockCalls
{
	public: /* Input Parameters */
	T1 ObjectPerBar;
	T2 ObjectUpdate;
	T3 ObjName;
	T4 ObjectType;
	T5 ObjTime1; virtual _T5_ _ObjTime1_(){return(_T5_)0;}
	T6 ObjPrice1; virtual _T6_ _ObjPrice1_(){return(_T6_)0;}
	T7 ObjX;
	T8 ObjY;
	T9 ObjText; virtual _T9_ _ObjText_(){return(_T9_)0;}
	T10 ObjFont;
	T11 ObjFontSize;
	T12 ObjAngle;
	T13 ObjCorner;
	T14 ObjAnchor;
	T15 ObjColor;
	T16 ObjBack;
	T17 ObjSelectable;
	T18 ObjSelected;
	T19 ObjHidden;
	T20 ObjZorder;
	T21 ObjChartSubWindow;
	/* Static Parameters */
	int count;
	datetime time0;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_ChartDrawText()
	{
		ObjectPerBar = (bool)true;
		ObjectUpdate = (bool)true;
		ObjName = (string)"";
		ObjectType = (ENUM_OBJECT)OBJ_TEXT;
		ObjX = (int)0;
		ObjY = (int)0;
		ObjFont = (string)"Arial";
		ObjFontSize = (int)10;
		ObjAngle = (double)0.0;
		ObjCorner = (ENUM_BASE_CORNER)CORNER_LEFT_UPPER;
		ObjAnchor = (int)ANCHOR_LEFT_UPPER;
		ObjColor = (color)clrSkyBlue;
		ObjBack = (bool)false;
		ObjSelectable = (bool)true;
		ObjSelected = (bool)false;
		ObjHidden = (bool)false;
		ObjZorder = (int)0;
		ObjChartSubWindow = (string)"";
		/* Static Parameters (initial value) */
		count =  0;
		time0 =  0;
	}

	public: /* The main method */
	virtual void _execute_()
	{
		string ObjNamePrefix = "fxd_text_";
		long ObjChartID      = 0;
		int subwindow_id     = WindowFindVisible(ObjChartID, ObjChartSubWindow);
		
		if (subwindow_id >= 0)
		{
			string name       = "";
			string name_base  = "";
			bool get_new_name = false;
			bool do_update    = true;
		
			if (ObjectPerBar == true)
			{
				datetime time = iTime(Symbol(),0,1);
		
				if (time0 < time)
				{
					time0        = time;
					get_new_name = true;
				}
				else
				{
					if (ObjectUpdate == false) {do_update = false;}
				}
			}
			else
			{
				if (ObjectUpdate == false) {get_new_name = true;}
			}
		
			if (do_update)
			{
				if (ObjName != "") {name_base = ObjName;} else {name_base = ObjNamePrefix + __block_user_number + "_";}
		
				if (get_new_name == false)
				{
					name = name_base + IntegerToString(count);
				}
				else
				{
					while (true)
					{
						count++;
						name = name_base + IntegerToString(count);
		
						if (ObjectFind(ObjChartID,name) < 0) {break;}
					}
				}
		
				if (ObjName != "" && count == 0) {name = ObjName;}
		
				if (ObjectFind(ObjChartID,name) < 0 && !ObjectCreate(ObjChartID,name,(ENUM_OBJECT)ObjectType,subwindow_id,0,0))
				{
					Print(__FUNCTION__,": failed to create text object! Error code = ",GetLastError());
				}
				
				double p1=0, p2=0;
				datetime t1=0, t2=0;
		
				if (ObjectType == OBJ_TEXT)
				{
					ObjectSetInteger(ObjChartID,name,OBJPROP_TIME,0,(long)_ObjTime1_());
					ObjectSetDouble(ObjChartID,name,OBJPROP_PRICE,0,(double)_ObjPrice1_());
				}
				else
				{
					ObjectSetInteger(ObjChartID,name,OBJPROP_XDISTANCE,ObjX);
					ObjectSetInteger(ObjChartID,name,OBJPROP_YDISTANCE,ObjY);
				}
		
				ObjectSetString(ObjChartID,name,OBJPROP_TEXT,(string)(_ObjText_()));
				ObjectSetString(ObjChartID,name,OBJPROP_FONT,ObjFont);
				ObjectSetInteger(ObjChartID,name,OBJPROP_FONTSIZE,ObjFontSize);
				ObjectSetDouble(ObjChartID,name,OBJPROP_ANGLE,ObjAngle);
				ObjectSetInteger(ObjChartID,name,OBJPROP_CORNER,ObjCorner);
				ObjectSetInteger(ObjChartID,name,OBJPROP_ANCHOR,ObjAnchor);
		
				//ObjectSetInteger(ObjChartID,name,OBJPROP_STYLE,ObjStyle);
				ObjectSetInteger(ObjChartID,name,OBJPROP_COLOR,ObjColor);
				ObjectSetInteger(ObjChartID,name,OBJPROP_BACK,ObjBack);
				//ObjectSetInteger(ObjChartID,name,OBJPROP_WIDTH,ObjWidth);
				ObjectSetInteger(ObjChartID,name,OBJPROP_SELECTABLE,ObjSelectable);
				ObjectSetInteger(ObjChartID,name,OBJPROP_SELECTED,ObjSelected);
				ObjectSetInteger(ObjChartID,name,OBJPROP_HIDDEN,ObjHidden);
				ObjectSetInteger(ObjChartID,name,OBJPROP_ZORDER,ObjZorder);
		
				ChartRedraw();
			}
		}
		
		_callback_(1);
	}
};

// "Condition" model
template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_,typename T4>
class MDL_Condition: public BlockCalls
{
	public: /* Input Parameters */
	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;}
	T2 compare;
	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;}
	T4 crosswidth;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_Condition()
	{
		compare = (string)">";
		crosswidth = (int)1;
	}

	public: /* The main method */
	virtual void _execute_()
	{
		bool output1 = false, output2 = false; // output 1 and output 2
		int crossover = 0;
		
		if (compare == "x>" || compare == "x<") {crossover = 1;}
		
		for (int i = 0; i <= crossover; i++)
		{
			// i=0 - normal pass, i=1 - crossover pass
		
			// Left operand of the condition
			FXD_MORE_SHIFT = i * crosswidth;
			_T1_ lo = _Lo_();
			if (MathAbs(lo) == EMPTY_VALUE) {return;}
		
			// Right operand of the condition
			FXD_MORE_SHIFT = i * crosswidth;
			_T3_ ro = _Ro_();
			if (MathAbs(ro) == EMPTY_VALUE) {return;}
		
			// Conditions
			if (CompareValues(compare, lo, ro))
			{
				if (i == 0)
				{
					output1 = true;
				}
			}
			else
			{
				if (i == 0)
				{
					output2 = true;
				}
				else
				{
					output2 = false;
				}
			}
		
			if (crossover == 1)
			{
				if (CompareValues(compare, ro, lo))
				{
					if (i == 0)
					{
						output2 = true;
					}
				}
				else
				{
					if (i == 1)
					{
						output1 = false;
					}
				}
			}
		}
		
		FXD_MORE_SHIFT = 0; // reset
		
			  if (output1 == true) {_callback_(1);}
		else if (output2 == true) {_callback_(0);}
	}
};

// "Delete objects" model
template<typename T1,typename T2,typename T3,typename T4,typename T5,typename T6>
class MDL_ChartDeleteObjects: public BlockCalls
{
	public: /* Input Parameters */
	T1 NameStartsWith;
	T2 NameContains;
	T3 ObjColor;
	T4 SortMode;
	T5 MaxObjects;
	T6 SkipObjects;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_ChartDeleteObjects()
	{
		NameStartsWith = (string)"";
		NameContains = (string)"";
		ObjColor = (color)EMPTY_VALUE;
		SortMode = (string)"z-a";
		MaxObjects = (int)0;
		SkipObjects = (int)0;
	}

	public: /* The main method */
	virtual void _execute_()
	{
		// TODO: Combine "a-z" and "z-a" loops into one loop
		// TODO: Fix the problem with "Any color" and the EMPTY_VALUE value
		
		int index         = 0;
		int total         = ObjectsTotal(0,-1,-1);
		int length        = 0;
		bool deleted      = false;
		int deleted_count = 0;
		int skipped_count = 0;
		string name       = "";
		
		if (SortMode == "a-z")
		{
			for (index=0; index<total; index++)
			{
				name = ObjectName(0,index);
		
				if (name != "")
				{
					if (MaxObjects > 0 && deleted_count >= MaxObjects) {break;}
		
					deleted = false;
		
					// ObjColor != clrBlack below is because in MQL5 when the value is EMPTY_VALUE, it is turned into clrBlack because of the data type
					if (ObjColor != EMPTY_VALUE && ObjColor != clrBlack && ObjectGetInteger(0, name, OBJPROP_COLOR) != ObjColor) {continue;}
		
					if (NameStartsWith == "" && NameContains == "")
					{
						if (SkipObjects > 0 && skipped_count < SkipObjects)
						{
							skipped_count++;
							continue;
						}
		
						if (ObjectDelete(0,name))
						{
							deleted_count++;
						}
					}
					else
					{
						if (NameStartsWith != "")
						{
							length = StringLen(NameStartsWith);
		
							if (StringSubstr(name,0,length) == NameStartsWith)
							{
								if (SkipObjects > 0 && skipped_count < SkipObjects)
								{
									skipped_count++;
									continue;
								}
		
								if (ObjectDelete(0,name))
								{
									deleted_count++;
								}
							}
						}
		
						if (deleted == false && NameContains != "")
						{
							if (StringFind(name,NameContains,0) > -1)
							{
								if (SkipObjects > 0 && skipped_count < SkipObjects)
								{
									skipped_count++;
									continue;
								}
		
								if (ObjectDelete(0,name))
								{
									deleted_count++;
								}
							}
						}
					}
				}
			}
		}
		else if (SortMode == "z-a")
		{
			for (index=total-1; index>=0; index--)
			{
				name = ObjectName(0,index);
		
				if (name != "")
				{
					if (MaxObjects > 0 && deleted_count >= MaxObjects) {break;}
		
					deleted = false;
		
					// ObjColor != clrBlack below is because in MQL5 when the value is EMPTY_VALUE, it is turned into clrBlack because of the data type
					if (ObjColor != EMPTY_VALUE && ObjColor != clrBlack && ObjectGetInteger(0, name, OBJPROP_COLOR) != ObjColor) {continue;}
		
					if (NameStartsWith == "" && NameContains == "")
					{
						if (SkipObjects > 0 && skipped_count < SkipObjects)
						{
							skipped_count++;
							continue;
						}
		
						if (ObjectDelete(0,name))
						{
							deleted_count++;
						}
					}
					else
					{
						if (NameStartsWith != "")
						{
							length = StringLen(NameStartsWith);
		
							if (StringSubstr(name,0,length) == NameStartsWith)
							{
								if (SkipObjects > 0 && skipped_count < SkipObjects)
								{
									skipped_count++;
									continue;
								}
		
								if (ObjectDelete(0,name))
								{
									deleted_count++;
								}
							}
						}
		
						if (deleted == false && NameContains != "")
						{
							if (StringFind(name,NameContains,0) > -1)
							{
								if (SkipObjects > 0 && skipped_count < SkipObjects)
								{
									skipped_count++;
									continue;
								}
		
								if (ObjectDelete(0,name))
								{
									deleted_count++;
								}
							}
						}
					}
				}
			}
		}
		
		if (deleted_count > 0)
		{
			ChartRedraw();
		}
		
		_callback_(1);
	}
};

// "Formula" model
template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_>
class MDL_Formula_1: public BlockCalls
{
	public: /* Input Parameters */
	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;}
	T2 compare;
	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;}
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_Formula_1()
	{
		compare = (string)"+";
	}

	public: /* The main method */
	virtual void _execute_()
	{
		_T1_ lo = _Lo_();
		if (typename(_T1_) != "string" && MathAbs(lo) == EMPTY_VALUE) {return;}
		
		_T3_ ro = _Ro_();
		if (typename(_T3_) != "string" && MathAbs(ro) == EMPTY_VALUE) {return;}
		
		v::sl_distance_pip = formula(compare, lo, ro);
		
		_callback_(1);
	}
};

// "Formula" model
template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_>
class MDL_Formula_2: public BlockCalls
{
	public: /* Input Parameters */
	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;}
	T2 compare;
	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;}
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_Formula_2()
	{
		compare = (string)"+";
	}

	public: /* The main method */
	virtual void _execute_()
	{
		_T1_ lo = _Lo_();
		if (typename(_T1_) != "string" && MathAbs(lo) == EMPTY_VALUE) {return;}
		
		_T3_ ro = _Ro_();
		if (typename(_T3_) != "string" && MathAbs(ro) == EMPTY_VALUE) {return;}
		
		v::tp_distance_pip = formula(compare, lo, ro);
		
		_callback_(1);
	}
};

// "Formula" model
template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_>
class MDL_Formula_3: public BlockCalls
{
	public: /* Input Parameters */
	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;}
	T2 compare;
	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;}
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_Formula_3()
	{
		compare = (string)"+";
	}

	public: /* The main method */
	virtual void _execute_()
	{
		_T1_ lo = _Lo_();
		if (typename(_T1_) != "string" && MathAbs(lo) == EMPTY_VALUE) {return;}
		
		_T3_ ro = _Ro_();
		if (typename(_T3_) != "string" && MathAbs(ro) == EMPTY_VALUE) {return;}
		
		v::sl_distance_pip = formula(compare, lo, ro);
		
		_callback_(1);
	}
};

// "Formula" model
template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_>
class MDL_Formula_4: public BlockCalls
{
	public: /* Input Parameters */
	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;}
	T2 compare;
	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;}
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_Formula_4()
	{
		compare = (string)"+";
	}

	public: /* The main method */
	virtual void _execute_()
	{
		_T1_ lo = _Lo_();
		if (typename(_T1_) != "string" && MathAbs(lo) == EMPTY_VALUE) {return;}
		
		_T3_ ro = _Ro_();
		if (typename(_T3_) != "string" && MathAbs(ro) == EMPTY_VALUE) {return;}
		
		v::tp_distance_pip = formula(compare, lo, ro);
		
		_callback_(1);
	}
};

// "Formula" model
template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_>
class MDL_Formula_5: public BlockCalls
{
	public: /* Input Parameters */
	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;}
	T2 compare;
	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;}
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_Formula_5()
	{
		compare = (string)"+";
	}

	public: /* The main method */
	virtual void _execute_()
	{
		_T1_ lo = _Lo_();
		if (typename(_T1_) != "string" && MathAbs(lo) == EMPTY_VALUE) {return;}
		
		_T3_ ro = _Ro_();
		if (typename(_T3_) != "string" && MathAbs(ro) == EMPTY_VALUE) {return;}
		
		v::sl_distance_pip = formula(compare, lo, ro);
		
		_callback_(1);
	}
};

// "Formula" model
template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_>
class MDL_Formula_6: public BlockCalls
{
	public: /* Input Parameters */
	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;}
	T2 compare;
	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;}
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_Formula_6()
	{
		compare = (string)"+";
	}

	public: /* The main method */
	virtual void _execute_()
	{
		_T1_ lo = _Lo_();
		if (typename(_T1_) != "string" && MathAbs(lo) == EMPTY_VALUE) {return;}
		
		_T3_ ro = _Ro_();
		if (typename(_T3_) != "string" && MathAbs(ro) == EMPTY_VALUE) {return;}
		
		v::tp_distance_pip = formula(compare, lo, ro);
		
		_callback_(1);
	}
};

// "Formula" model
template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_>
class MDL_Formula_7: public BlockCalls
{
	public: /* Input Parameters */
	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;}
	T2 compare;
	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;}
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_Formula_7()
	{
		compare = (string)"+";
	}

	public: /* The main method */
	virtual void _execute_()
	{
		_T1_ lo = _Lo_();
		if (typename(_T1_) != "string" && MathAbs(lo) == EMPTY_VALUE) {return;}
		
		_T3_ ro = _Ro_();
		if (typename(_T3_) != "string" && MathAbs(ro) == EMPTY_VALUE) {return;}
		
		v::sl_distance_pip = formula(compare, lo, ro);
		
		_callback_(1);
	}
};

// "Formula" model
template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_>
class MDL_Formula_8: public BlockCalls
{
	public: /* Input Parameters */
	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;}
	T2 compare;
	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;}
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_Formula_8()
	{
		compare = (string)"+";
	}

	public: /* The main method */
	virtual void _execute_()
	{
		_T1_ lo = _Lo_();
		if (typename(_T1_) != "string" && MathAbs(lo) == EMPTY_VALUE) {return;}
		
		_T3_ ro = _Ro_();
		if (typename(_T3_) != "string" && MathAbs(ro) == EMPTY_VALUE) {return;}
		
		v::tp_distance_pip = formula(compare, lo, ro);
		
		_callback_(1);
	}
};

// "Once per tick" model
template<typename T1>
class MDL_OncePerTick: public BlockCalls
{
	public: /* Input Parameters */
	T1 Symbol;
	/* Static Parameters */
	datetime t0;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_OncePerTick()
	{
		Symbol = (string)CurrentSymbol();
	}

	public: /* The main method */
	virtual void _execute_()
	{
		static double a0, b0;
		
		
		double a   = SymbolInfoDouble(Symbol,SYMBOL_ASK);
		double b   = SymbolInfoDouble(Symbol,SYMBOL_BID);
		datetime t = (datetime)SymbolInfoInteger(Symbol,SYMBOL_TIME);
		
		if (t != t0 || a != a0 || b != b0)
		{
			t0 = t;
			a0 = a;
			b0 = b;
		
			_callback_(1);
		}
		else
		{
			_callback_(0);
		}
	}
};

// "Buy pending order" model
template<typename T1,typename T2,typename T3,typename T4,typename _T4_,typename T5,typename T6,typename T7,typename T8,typename T9,typename T10,typename T11,typename T12,typename _T12_,typename T13,typename T14,typename T15,typename T16,typename T17,typename T18,typename T19,typename T20,typename T21,typename T22,typename T23,typename T24,typename T25,typename T26,typename T27,typename _T27_,typename T28,typename _T28_,typename T29,typename _T29_,typename T30,typename T31,typename T32,typename T33,typename T34,typename _T34_,typename T35,typename _T35_,typename T36,typename _T36_,typename T37,typename T38,typename T39,typename T40,typename T41,typename _T41_,typename T42,typename T43,typename T44,typename T45>
class MDL_BuyPending: public BlockCalls
{
	public: /* Input Parameters */
	T1 Group;
	T2 Symbol;
	T3 Price;
	T4 dPrice; virtual _T4_ _dPrice_(){return(_T4_)0;}
	T5 PriceOffset;
	T6 VolumeMode;
	T7 VolumeSize;
	T8 VolumeSizeRisk;
	T9 VolumeRisk;
	T10 VolumePercent;
	T11 VolumeBlockPercent;
	T12 dVolumeSize; virtual _T12_ _dVolumeSize_(){return(_T12_)0;}
	T13 FixedRatioUnitSize;
	T14 FixedRatioDelta;
	T15 mmMgInitialLots;
	T16 mmMgMultiplyOnLoss;
	T17 mmMgMultiplyOnProfit;
	T18 mmMgAddLotsOnLoss;
	T19 mmMgAddLotsOnProfit;
	T20 mmMgResetOnLoss;
	T21 mmMgResetOnProfit;
	T22 VolumeUpperLimit;
	T23 StopLossMode;
	T24 StopLossPips;
	T25 StopLossPercentPrice;
	T26 StopLossPercentTP;
	T27 dlStopLoss; virtual _T27_ _dlStopLoss_(){return(_T27_)0;}
	T28 dpStopLoss; virtual _T28_ _dpStopLoss_(){return(_T28_)0;}
	T29 ddStopLoss; virtual _T29_ _ddStopLoss_(){return(_T29_)0;}
	T30 TakeProfitMode;
	T31 TakeProfitPips;
	T32 TakeProfitPercentPrice;
	T33 TakeProfitPercentSL;
	T34 dlTakeProfit; virtual _T34_ _dlTakeProfit_(){return(_T34_)0;}
	T35 ddTakeProfit; virtual _T35_ _ddTakeProfit_(){return(_T35_)0;}
	T36 dpTakeProfit; virtual _T36_ _dpTakeProfit_(){return(_T36_)0;}
	T37 ExpMode;
	T38 ExpDays;
	T39 ExpHours;
	T40 ExpMinutes;
	T41 dExp; virtual _T41_ _dExp_(){return(_T41_)0;}
	T42 CreateOCO;
	T43 Slippage;
	T44 MyComment;
	T45 ArrowColorBuy;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_BuyPending()
	{
		Group = (string)"";
		Symbol = (string)CurrentSymbol();
		Price = (string)"ask";
		PriceOffset = (double)20.0;
		VolumeMode = (string)"fixed";
		VolumeSize = (double)0.1;
		VolumeSizeRisk = (double)50.0;
		VolumeRisk = (double)2.5;
		VolumePercent = (double)100.0;
		VolumeBlockPercent = (double)3.0;
		FixedRatioUnitSize = (double)0.01;
		FixedRatioDelta = (double)20.0;
		mmMgInitialLots = (double)0.1;
		mmMgMultiplyOnLoss = (double)2.0;
		mmMgMultiplyOnProfit = (double)1.0;
		mmMgAddLotsOnLoss = (double)0.0;
		mmMgAddLotsOnProfit = (double)0.0;
		mmMgResetOnLoss = (int)0;
		mmMgResetOnProfit = (int)1;
		VolumeUpperLimit = (double)0.0;
		StopLossMode = (string)"fixed";
		StopLossPips = (double)50.0;
		StopLossPercentPrice = (double)0.55;
		StopLossPercentTP = (double)100.0;
		TakeProfitMode = (string)"fixed";
		TakeProfitPips = (double)50.0;
		TakeProfitPercentPrice = (double)0.55;
		TakeProfitPercentSL = (double)100.0;
		ExpMode = (string)"GTC";
		ExpDays = (int)0;
		ExpHours = (int)1;
		ExpMinutes = (int)0;
		CreateOCO = (int)0;
		Slippage = (ulong)4;
		MyComment = (string)"";
		ArrowColorBuy = (color)clrBlue;
	}

	public: /* The main method */
	virtual void _execute_()
	{
		//-- open price -------------------------------------------------------------
		double op = 0;
		
		     if (Price == "ask")     {op = SymbolAsk(Symbol);}
		else if (Price == "bid")     {op = SymbolBid(Symbol);}
		else if (Price == "mid")     {op = (SymbolAsk(Symbol)+SymbolBid(Symbol))/2;}
		else if (Price == "dynamic") {op = _dPrice_();}
		
		op = op + toDigits(PriceOffset, Symbol);
		
		//-- stops ------------------------------------------------------------------
		double sll = 0, slp = 0, tpl = 0, tpp = 0;
		
		     if (StopLossMode == "fixed")         {slp = StopLossPips;}
		else if (StopLossMode == "dynamicPips")   {slp = _dpStopLoss_();}
		else if (StopLossMode == "dynamicDigits") {slp = toPips(_ddStopLoss_(),Symbol);}
		else if (StopLossMode == "dynamicLevel")  {sll = _dlStopLoss_();}
		else if (StopLossMode == "percentPrice")  {sll = op - (op * StopLossPercentPrice / 100);}
		
		     if (TakeProfitMode == "fixed")         {tpp = TakeProfitPips;}
		else if (TakeProfitMode == "dynamicPips")   {tpp = _dpTakeProfit_();}
		else if (TakeProfitMode == "dynamicDigits") {tpp = toPips(_ddTakeProfit_(),Symbol);}
		else if (TakeProfitMode == "dynamicLevel")  {tpl = _dlTakeProfit_();}
		else if (TakeProfitMode == "percentPrice")  {tpl = op + (op * TakeProfitPercentPrice / 100);}
		
		if (StopLossMode == "percentTP")
		{
			if (tpp > 0) {slp = tpp*StopLossPercentTP/100;}
			if (tpl > 0) {slp = toPips(MathAbs(op - tpl), Symbol)*StopLossPercentTP/100;}
		}
		
		if (TakeProfitMode == "percentSL")
		{
			if (slp > 0) {tpp = slp*TakeProfitPercentSL/100;}
			if (sll > 0) {tpp = toPips(MathAbs(op - sll), Symbol)*TakeProfitPercentSL/100;}
		}
		
		//-- lots -------------------------------------------------------------------
		double lots    = 0;
		double pre_sll = sll;
		
		if (pre_sll == 0) {pre_sll = op;}
		
		double pre_sl_pips = toPips(op-(pre_sll-toDigits(slp,Symbol)), Symbol);
		
		     if (VolumeMode == "fixed")            {lots = DynamicLots(Symbol, VolumeMode, VolumeSize);}
		else if (VolumeMode == "block-equity")     {lots = DynamicLots(Symbol, VolumeMode, VolumeBlockPercent);}
		else if (VolumeMode == "block-balance")    {lots = DynamicLots(Symbol, VolumeMode, VolumeBlockPercent);}
		else if (VolumeMode == "block-freemargin") {lots = DynamicLots(Symbol, VolumeMode, VolumeBlockPercent);}
		else if (VolumeMode == "equity")           {lots = DynamicLots(Symbol, VolumeMode, VolumePercent);}
		else if (VolumeMode == "balance")          {lots = DynamicLots(Symbol, VolumeMode, VolumePercent);}
		else if (VolumeMode == "freemargin")       {lots = DynamicLots(Symbol, VolumeMode, VolumePercent);}
		else if (VolumeMode == "equityRisk")       {lots = DynamicLots(Symbol, VolumeMode, VolumeRisk, pre_sl_pips);}
		else if (VolumeMode == "safeMargin")       {lots = DynamicLots(Symbol, VolumeMode, VolumeRisk, pre_sl_pips);}
		else if (VolumeMode == "balanceRisk")      {lots = DynamicLots(Symbol, VolumeMode, VolumeRisk, pre_sl_pips);}
		else if (VolumeMode == "freemarginRisk")   {lots = DynamicLots(Symbol, VolumeMode, VolumeRisk, pre_sl_pips);}
		else if (VolumeMode == "fixedRisk")        {lots = DynamicLots(Symbol, VolumeMode, VolumeSizeRisk, pre_sl_pips);}
		else if (VolumeMode == "fixedRatio")       {lots = DynamicLots(Symbol, VolumeMode, FixedRatioUnitSize, FixedRatioDelta);}
		else if (VolumeMode == "martingale")       {lots = BetMartingale(Group, Symbol, 0, mmMgInitialLots, mmMgMultiplyOnLoss, mmMgMultiplyOnProfit, mmMgAddLotsOnLoss, mmMgAddLotsOnProfit, mmMgResetOnLoss, mmMgResetOnProfit);}
		else if (VolumeMode == "dynamic")          {lots = _dVolumeSize_();}
		
		lots = AlignLots(Symbol, lots, 0, VolumeUpperLimit);
		
		//-- expiration -------------------------------------------------------------
		datetime exp = ExpirationTime(ExpMode,ExpDays,ExpHours,ExpMinutes,_dExp_());
		
		//-- send -------------------------------------------------------------------
		long ticket = BuyLater(Symbol,lots,op,sll,tpl,slp,tpp,Slippage,exp,(MagicStart+(int)Group),MyComment,ArrowColorBuy,CreateOCO);
		
		if (ticket > 0) {_callback_(1);} else {_callback_(0);}
	}
};

// "Sell pending order" model
template<typename T1,typename T2,typename T3,typename T4,typename _T4_,typename T5,typename T6,typename T7,typename T8,typename T9,typename T10,typename T11,typename T12,typename _T12_,typename T13,typename T14,typename T15,typename T16,typename T17,typename T18,typename T19,typename T20,typename T21,typename T22,typename T23,typename T24,typename T25,typename T26,typename T27,typename _T27_,typename T28,typename _T28_,typename T29,typename _T29_,typename T30,typename T31,typename T32,typename T33,typename T34,typename _T34_,typename T35,typename _T35_,typename T36,typename _T36_,typename T37,typename T38,typename T39,typename T40,typename T41,typename _T41_,typename T42,typename T43,typename T44,typename T45>
class MDL_SellPending: public BlockCalls
{
	public: /* Input Parameters */
	T1 Group;
	T2 Symbol;
	T3 Price;
	T4 dPrice; virtual _T4_ _dPrice_(){return(_T4_)0;}
	T5 PriceOffset;
	T6 VolumeMode;
	T7 VolumeSize;
	T8 VolumeSizeRisk;
	T9 VolumeRisk;
	T10 VolumePercent;
	T11 VolumeBlockPercent;
	T12 dVolumeSize; virtual _T12_ _dVolumeSize_(){return(_T12_)0;}
	T13 FixedRatioUnitSize;
	T14 FixedRatioDelta;
	T15 mmMgInitialLots;
	T16 mmMgMultiplyOnLoss;
	T17 mmMgMultiplyOnProfit;
	T18 mmMgAddLotsOnLoss;
	T19 mmMgAddLotsOnProfit;
	T20 mmMgResetOnLoss;
	T21 mmMgResetOnProfit;
	T22 VolumeUpperLimit;
	T23 StopLossMode;
	T24 StopLossPips;
	T25 StopLossPercentPrice;
	T26 StopLossPercentTP;
	T27 dlStopLoss; virtual _T27_ _dlStopLoss_(){return(_T27_)0;}
	T28 dpStopLoss; virtual _T28_ _dpStopLoss_(){return(_T28_)0;}
	T29 ddStopLoss; virtual _T29_ _ddStopLoss_(){return(_T29_)0;}
	T30 TakeProfitMode;
	T31 TakeProfitPips;
	T32 TakeProfitPercentPrice;
	T33 TakeProfitPercentSL;
	T34 dlTakeProfit; virtual _T34_ _dlTakeProfit_(){return(_T34_)0;}
	T35 ddTakeProfit; virtual _T35_ _ddTakeProfit_(){return(_T35_)0;}
	T36 dpTakeProfit; virtual _T36_ _dpTakeProfit_(){return(_T36_)0;}
	T37 ExpMode;
	T38 ExpDays;
	T39 ExpHours;
	T40 ExpMinutes;
	T41 dExp; virtual _T41_ _dExp_(){return(_T41_)0;}
	T42 CreateOCO;
	T43 Slippage;
	T44 MyComment;
	T45 ArrowColorSell;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_SellPending()
	{
		Group = (string)"";
		Symbol = (string)CurrentSymbol();
		Price = (string)"bid";
		PriceOffset = (double)20.0;
		VolumeMode = (string)"fixed";
		VolumeSize = (double)0.1;
		VolumeSizeRisk = (double)50.0;
		VolumeRisk = (double)2.5;
		VolumePercent = (double)100.0;
		VolumeBlockPercent = (double)3.0;
		FixedRatioUnitSize = (double)0.01;
		FixedRatioDelta = (double)20.0;
		mmMgInitialLots = (double)0.1;
		mmMgMultiplyOnLoss = (double)2.0;
		mmMgMultiplyOnProfit = (double)1.0;
		mmMgAddLotsOnLoss = (double)0.0;
		mmMgAddLotsOnProfit = (double)0.0;
		mmMgResetOnLoss = (int)0;
		mmMgResetOnProfit = (int)1;
		VolumeUpperLimit = (double)0.0;
		StopLossMode = (string)"fixed";
		StopLossPips = (double)50.0;
		StopLossPercentPrice = (double)0.55;
		StopLossPercentTP = (double)100.0;
		TakeProfitMode = (string)"fixed";
		TakeProfitPips = (double)50.0;
		TakeProfitPercentPrice = (double)0.55;
		TakeProfitPercentSL = (double)100.0;
		ExpMode = (string)"GTC";
		ExpDays = (int)0;
		ExpHours = (int)1;
		ExpMinutes = (int)0;
		CreateOCO = (int)0;
		Slippage = (ulong)4;
		MyComment = (string)"";
		ArrowColorSell = (color)clrRed;
	}

	public: /* The main method */
	virtual void _execute_()
	{
		//-- open price -------------------------------------------------------------
		double op = 0;
		
		     if (Price == "ask")     {op = SymbolAsk(Symbol);}
		else if (Price == "bid")     {op = SymbolBid(Symbol);}
		else if (Price == "mid")     {op = (SymbolAsk(Symbol)+SymbolBid(Symbol))/2;}
		else if (Price == "dynamic") {op = _dPrice_();}
		
		op = op - toDigits(PriceOffset, Symbol);
		
		//-- stops ------------------------------------------------------------------
		double sll = 0, slp = 0, tpl = 0, tpp = 0;
		
		     if (StopLossMode == "fixed")         {slp = StopLossPips;}
		else if (StopLossMode == "dynamicPips")   {slp = _dpStopLoss_();}
		else if (StopLossMode == "dynamicDigits") {slp = toPips(_ddStopLoss_(),Symbol);}
		else if (StopLossMode == "dynamicLevel")  {sll = _dlStopLoss_();}
		else if (StopLossMode == "percentPrice")  {sll = op + (op * StopLossPercentPrice / 100);}
		
		     if (TakeProfitMode == "fixed")         {tpp = TakeProfitPips;}
		else if (TakeProfitMode == "dynamicPips")   {tpp = _dpTakeProfit_();}
		else if (TakeProfitMode == "dynamicDigits") {tpp = toPips(_ddTakeProfit_(),Symbol);}
		else if (TakeProfitMode == "dynamicLevel")  {tpl = _dlTakeProfit_();}
		else if (TakeProfitMode == "percentPrice")  {tpl = op - (op * TakeProfitPercentPrice / 100);}
		
		if (StopLossMode == "percentTP")
		{
			if (tpp > 0) {slp = tpp*StopLossPercentTP/100;}
			if (tpl > 0) {slp = toPips(MathAbs(op - tpl), Symbol)*StopLossPercentTP/100;}
		}
		
		if (TakeProfitMode == "percentSL")
		{
			if (slp > 0) {tpp = slp*TakeProfitPercentSL/100;}
			if (sll > 0) {tpp = toPips(MathAbs(op - sll), Symbol)*TakeProfitPercentSL/100;}
		}
		
		//-- lots -------------------------------------------------------------------
		double lots    = 0;
		double pre_sll = sll;
		
		if (pre_sll == 0) {pre_sll = op;}
		
		double pre_sl_pips = toPips((pre_sll+toDigits(slp,Symbol))-op, Symbol);
		
		     if (VolumeMode == "fixed")            {lots = DynamicLots(Symbol, VolumeMode, VolumeSize);}
		else if (VolumeMode == "block-equity")     {lots = DynamicLots(Symbol, VolumeMode, VolumeBlockPercent);}
		else if (VolumeMode == "block-balance")    {lots = DynamicLots(Symbol, VolumeMode, VolumeBlockPercent);}
		else if (VolumeMode == "block-freemargin") {lots = DynamicLots(Symbol, VolumeMode, VolumeBlockPercent);}
		else if (VolumeMode == "equity")           {lots = DynamicLots(Symbol, VolumeMode, VolumePercent);}
		else if (VolumeMode == "balance")          {lots = DynamicLots(Symbol, VolumeMode, VolumePercent);}
		else if (VolumeMode == "freemargin")       {lots = DynamicLots(Symbol, VolumeMode, VolumePercent);}
		else if (VolumeMode == "equityRisk")       {lots = DynamicLots(Symbol, VolumeMode, VolumeRisk, pre_sl_pips);}
		else if (VolumeMode == "safeMargin")       {lots = DynamicLots(Symbol, VolumeMode, VolumeRisk, pre_sl_pips);}
		else if (VolumeMode == "balanceRisk")      {lots = DynamicLots(Symbol, VolumeMode, VolumeRisk, pre_sl_pips);}
		else if (VolumeMode == "freemarginRisk")   {lots = DynamicLots(Symbol, VolumeMode, VolumeRisk, pre_sl_pips);}
		else if (VolumeMode == "fixedRisk")        {lots = DynamicLots(Symbol, VolumeMode, VolumeSizeRisk, pre_sl_pips);}
		else if (VolumeMode == "fixedRatio")       {lots = DynamicLots(Symbol, VolumeMode, FixedRatioUnitSize, FixedRatioDelta);}
		else if (VolumeMode == "martingale")       {lots = BetMartingale(Group, Symbol, 0, mmMgInitialLots, mmMgMultiplyOnLoss, mmMgMultiplyOnProfit, mmMgAddLotsOnLoss, mmMgAddLotsOnProfit, mmMgResetOnLoss, mmMgResetOnProfit);}
		else if (VolumeMode == "dynamic")          {lots = _dVolumeSize_();}
		
		lots = AlignLots(Symbol, lots, 0, VolumeUpperLimit);
		
		//-- expiration -------------------------------------------------------------
		datetime exp = ExpirationTime(ExpMode,ExpDays,ExpHours,ExpMinutes,_dExp_());
		
		//-- send -------------------------------------------------------------------
		long ticket = SellLater(Symbol,lots,op,sll,tpl,slp,tpp,Slippage,exp,(MagicStart+(int)Group),MyComment,ArrowColorSell,CreateOCO);
		
		if (ticket > 0) {_callback_(1);} else {_callback_(0);}
	}
};

// "Buy now" model
template<typename T1,typename T2,typename T3,typename T4,typename T5,typename T6,typename T7,typename T8,typename T9,typename _T9_,typename T10,typename T11,typename T12,typename T13,typename T14,typename T15,typename T16,typename T17,typename T18,typename T19,typename T20,typename T21,typename T22,typename T23,typename T24,typename T25,typename T26,typename T27,typename T28,typename T29,typename T30,typename T31,typename T32,typename T33,typename T34,typename T35,typename T36,typename T37,typename _T37_,typename T38,typename _T38_,typename T39,typename _T39_,typename T40,typename T41,typename T42,typename T43,typename T44,typename _T44_,typename T45,typename _T45_,typename T46,typename _T46_,typename T47,typename T48,typename T49,typename T50,typename T51,typename _T51_,typename T52,typename T53,typename T54>
class MDL_BuyNow: public BlockCalls
{
	public: /* Input Parameters */
	T1 Group;
	T2 Symbol;
	T3 VolumeMode;
	T4 VolumeSize;
	T5 VolumeSizeRisk;
	T6 VolumeRisk;
	T7 VolumePercent;
	T8 VolumeBlockPercent;
	T9 dVolumeSize; virtual _T9_ _dVolumeSize_(){return(_T9_)0;}
	T10 FixedRatioUnitSize;
	T11 FixedRatioDelta;
	T12 mmTradesPool;
	T13 mmMgInitialLots;
	T14 mmMgMultiplyOnLoss;
	T15 mmMgMultiplyOnProfit;
	T16 mmMgAddLotsOnLoss;
	T17 mmMgAddLotsOnProfit;
	T18 mmMgResetOnLoss;
	T19 mmMgResetOnProfit;
	T20 mm1326InitialLots;
	T21 mm1326Reverse;
	T22 mmFiboInitialLots;
	T23 mmDalembertInitialLots;
	T24 mmDalembertReverse;
	T25 mmLabouchereInitialLots;
	T26 mmLabouchereList;
	T27 mmLabouchereReverse;
	T28 mmSeqBaseLots;
	T29 mmSeqOnLoss;
	T30 mmSeqOnProfit;
	T31 mmSeqReverse;
	T32 VolumeUpperLimit;
	T33 StopLossMode;
	T34 StopLossPips;
	T35 StopLossPercentPrice;
	T36 StopLossPercentTP;
	T37 dlStopLoss; virtual _T37_ _dlStopLoss_(){return(_T37_)0;}
	T38 dpStopLoss; virtual _T38_ _dpStopLoss_(){return(_T38_)0;}
	T39 ddStopLoss; virtual _T39_ _ddStopLoss_(){return(_T39_)0;}
	T40 TakeProfitMode;
	T41 TakeProfitPips;
	T42 TakeProfitPercentPrice;
	T43 TakeProfitPercentSL;
	T44 dlTakeProfit; virtual _T44_ _dlTakeProfit_(){return(_T44_)0;}
	T45 dpTakeProfit; virtual _T45_ _dpTakeProfit_(){return(_T45_)0;}
	T46 ddTakeProfit; virtual _T46_ _ddTakeProfit_(){return(_T46_)0;}
	T47 ExpMode;
	T48 ExpDays;
	T49 ExpHours;
	T50 ExpMinutes;
	T51 dExp; virtual _T51_ _dExp_(){return(_T51_)0;}
	T52 Slippage;
	T53 MyComment;
	T54 ArrowColorBuy;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_BuyNow()
	{
		Group = (string)"";
		Symbol = (string)CurrentSymbol();
		VolumeMode = (string)"fixed";
		VolumeSize = (double)0.1;
		VolumeSizeRisk = (double)50.0;
		VolumeRisk = (double)2.5;
		VolumePercent = (double)100.0;
		VolumeBlockPercent = (double)3.0;
		FixedRatioUnitSize = (double)0.01;
		FixedRatioDelta = (double)20.0;
		mmTradesPool = (int)0;
		mmMgInitialLots = (double)0.1;
		mmMgMultiplyOnLoss = (double)2.0;
		mmMgMultiplyOnProfit = (double)1.0;
		mmMgAddLotsOnLoss = (double)0.0;
		mmMgAddLotsOnProfit = (double)0.0;
		mmMgResetOnLoss = (int)0;
		mmMgResetOnProfit = (int)1;
		mm1326InitialLots = (double)0.1;
		mm1326Reverse = (bool)false;
		mmFiboInitialLots = (double)0.1;
		mmDalembertInitialLots = (double)0.1;
		mmDalembertReverse = (bool)false;
		mmLabouchereInitialLots = (double)0.1;
		mmLabouchereList = (string)"1,2,3,4,5,6";
		mmLabouchereReverse = (bool)false;
		mmSeqBaseLots = (double)0.1;
		mmSeqOnLoss = (string)"3,2,6";
		mmSeqOnProfit = (string)"1";
		mmSeqReverse = (bool)false;
		VolumeUpperLimit = (double)0.0;
		StopLossMode = (string)"fixed";
		StopLossPips = (double)50.0;
		StopLossPercentPrice = (double)0.55;
		StopLossPercentTP = (double)100.0;
		TakeProfitMode = (string)"fixed";
		TakeProfitPips = (double)50.0;
		TakeProfitPercentPrice = (double)0.55;
		TakeProfitPercentSL = (double)100.0;
		ExpMode = (string)"GTC";
		ExpDays = (int)0;
		ExpHours = (int)1;
		ExpMinutes = (int)0;
		Slippage = (ulong)4;
		MyComment = (string)"";
		ArrowColorBuy = (color)clrBlue;
	}

	public: /* The main method */
	virtual void _execute_()
	{
		//-- stops ------------------------------------------------------------------
		double sll = 0, slp = 0, tpl = 0, tpp = 0;
		
		     if (StopLossMode == "fixed")         {slp = StopLossPips;}
		else if (StopLossMode == "dynamicPips")   {slp = _dpStopLoss_();}
		else if (StopLossMode == "dynamicDigits") {slp = toPips(_ddStopLoss_(),Symbol);}
		else if (StopLossMode == "dynamicLevel")  {sll = _dlStopLoss_();}
		else if (StopLossMode == "percentPrice")  {sll = SymbolAsk(Symbol) - (SymbolAsk(Symbol) * StopLossPercentPrice / 100);}
		
		     if (TakeProfitMode == "fixed")         {tpp = TakeProfitPips;}
		else if (TakeProfitMode == "dynamicPips")   {tpp = _dpTakeProfit_();}
		else if (TakeProfitMode == "dynamicDigits") {tpp = toPips(_ddTakeProfit_(),Symbol);}
		else if (TakeProfitMode == "dynamicLevel")  {tpl = _dlTakeProfit_();}
		else if (TakeProfitMode == "percentPrice")  {tpl = SymbolAsk(Symbol) + (SymbolAsk(Symbol) * TakeProfitPercentPrice / 100);}
		
		if (StopLossMode == "percentTP") {
		   if (tpp > 0) {slp = tpp*StopLossPercentTP/100;}
		   if (tpl > 0) {slp = toPips(MathAbs(SymbolAsk(Symbol) - tpl), Symbol)*StopLossPercentTP/100;}
		}
		if (TakeProfitMode == "percentSL") {
		   if (slp > 0) {tpp = slp*TakeProfitPercentSL/100;}
		   if (sll > 0) {tpp = toPips(MathAbs(SymbolAsk(Symbol) - sll), Symbol)*TakeProfitPercentSL/100;}
		}
		
		//-- lots -------------------------------------------------------------------
		double lots = 0;
		double pre_sll = sll;
		
		if (pre_sll == 0) {
			pre_sll = SymbolAsk(Symbol);
		}
		
		double pre_sl_pips = toPips(SymbolAsk(Symbol)-(pre_sll-toDigits(slp,Symbol)), Symbol);
		
		     if (VolumeMode == "fixed")            {lots = DynamicLots(Symbol, VolumeMode, VolumeSize);}
		else if (VolumeMode == "block-equity")     {lots = DynamicLots(Symbol, VolumeMode, VolumeBlockPercent);}
		else if (VolumeMode == "block-balance")    {lots = DynamicLots(Symbol, VolumeMode, VolumeBlockPercent);}
		else if (VolumeMode == "block-freemargin") {lots = DynamicLots(Symbol, VolumeMode, VolumeBlockPercent);}
		else if (VolumeMode == "equity")           {lots = DynamicLots(Symbol, VolumeMode, VolumePercent);}
		else if (VolumeMode == "balance")          {lots = DynamicLots(Symbol, VolumeMode, VolumePercent);}
		else if (VolumeMode == "freemargin")       {lots = DynamicLots(Symbol, VolumeMode, VolumePercent);}
		else if (VolumeMode == "equityRisk")       {lots = DynamicLots(Symbol, VolumeMode, VolumeRisk, pre_sl_pips);}
		else if (VolumeMode == "balanceRisk")      {lots = DynamicLots(Symbol, VolumeMode, VolumeRisk, pre_sl_pips);}
		else if (VolumeMode == "freemarginRisk")   {lots = DynamicLots(Symbol, VolumeMode, VolumeRisk, pre_sl_pips);}
		else if (VolumeMode == "fixedRisk")        {lots = DynamicLots(Symbol, VolumeMode, VolumeSizeRisk, pre_sl_pips);}
		else if (VolumeMode == "fixedRatio")       {lots = DynamicLots(Symbol, VolumeMode, FixedRatioUnitSize, FixedRatioDelta);}
		else if (VolumeMode == "dynamic")          {lots = _dVolumeSize_();}
		else if (VolumeMode == "1326")             {lots = Bet1326(Group, Symbol, mmTradesPool, mm1326InitialLots, mm1326Reverse);}
		else if (VolumeMode == "fibonacci")        {lots = BetFibonacci(Group, Symbol, mmTradesPool, mmFiboInitialLots);}
		else if (VolumeMode == "dalembert")        {lots = BetDalembert(Group, Symbol, mmTradesPool, mmDalembertInitialLots, mmDalembertReverse);}
		else if (VolumeMode == "labouchere")       {lots = BetLabouchere(Group, Symbol, mmTradesPool, mmLabouchereInitialLots, mmLabouchereList, mmLabouchereReverse);}
		else if (VolumeMode == "martingale")       {lots = BetMartingale(Group, Symbol, mmTradesPool, mmMgInitialLots, mmMgMultiplyOnLoss, mmMgMultiplyOnProfit, mmMgAddLotsOnLoss, mmMgAddLotsOnProfit, mmMgResetOnLoss, mmMgResetOnProfit);}
		else if (VolumeMode == "sequence")         {lots = BetSequence(Group, Symbol, mmTradesPool, mmSeqBaseLots, mmSeqOnLoss, mmSeqOnProfit, mmSeqReverse);}
		
		lots = AlignLots(Symbol, lots, 0, VolumeUpperLimit);
		
		datetime exp = ExpirationTime(ExpMode,ExpDays,ExpHours,ExpMinutes,_dExp_());
		
		//-- send -------------------------------------------------------------------
		long ticket = BuyNow(Symbol, lots, sll, tpl, slp, tpp, Slippage, (MagicStart+(int)Group), MyComment, ArrowColorBuy, exp);
		
		if (ticket > 0) {_callback_(1);} else {_callback_(0);}
	}
};

// "Sell now" model
template<typename T1,typename T2,typename T3,typename T4,typename T5,typename T6,typename T7,typename T8,typename T9,typename _T9_,typename T10,typename T11,typename T12,typename T13,typename T14,typename T15,typename T16,typename T17,typename T18,typename T19,typename T20,typename T21,typename T22,typename T23,typename T24,typename T25,typename T26,typename T27,typename T28,typename T29,typename T30,typename T31,typename T32,typename T33,typename T34,typename T35,typename T36,typename T37,typename _T37_,typename T38,typename _T38_,typename T39,typename _T39_,typename T40,typename T41,typename T42,typename T43,typename T44,typename _T44_,typename T45,typename _T45_,typename T46,typename _T46_,typename T47,typename T48,typename T49,typename T50,typename T51,typename _T51_,typename T52,typename T53,typename T54>
class MDL_SellNow: public BlockCalls
{
	public: /* Input Parameters */
	T1 Group;
	T2 Symbol;
	T3 VolumeMode;
	T4 VolumeSize;
	T5 VolumeSizeRisk;
	T6 VolumeRisk;
	T7 VolumePercent;
	T8 VolumeBlockPercent;
	T9 dVolumeSize; virtual _T9_ _dVolumeSize_(){return(_T9_)0;}
	T10 FixedRatioUnitSize;
	T11 FixedRatioDelta;
	T12 mmTradesPool;
	T13 mmMgInitialLots;
	T14 mmMgMultiplyOnLoss;
	T15 mmMgMultiplyOnProfit;
	T16 mmMgAddLotsOnLoss;
	T17 mmMgAddLotsOnProfit;
	T18 mmMgResetOnLoss;
	T19 mmMgResetOnProfit;
	T20 mm1326InitialLots;
	T21 mm1326Reverse;
	T22 mmFiboInitialLots;
	T23 mmDalembertInitialLots;
	T24 mmDalembertReverse;
	T25 mmLabouchereInitialLots;
	T26 mmLabouchereList;
	T27 mmLabouchereReverse;
	T28 mmSeqBaseLots;
	T29 mmSeqOnLoss;
	T30 mmSeqOnProfit;
	T31 mmSeqReverse;
	T32 VolumeUpperLimit;
	T33 StopLossMode;
	T34 StopLossPips;
	T35 StopLossPercentPrice;
	T36 StopLossPercentTP;
	T37 dlStopLoss; virtual _T37_ _dlStopLoss_(){return(_T37_)0;}
	T38 dpStopLoss; virtual _T38_ _dpStopLoss_(){return(_T38_)0;}
	T39 ddStopLoss; virtual _T39_ _ddStopLoss_(){return(_T39_)0;}
	T40 TakeProfitMode;
	T41 TakeProfitPips;
	T42 TakeProfitPercentPrice;
	T43 TakeProfitPercentSL;
	T44 dlTakeProfit; virtual _T44_ _dlTakeProfit_(){return(_T44_)0;}
	T45 dpTakeProfit; virtual _T45_ _dpTakeProfit_(){return(_T45_)0;}
	T46 ddTakeProfit; virtual _T46_ _ddTakeProfit_(){return(_T46_)0;}
	T47 ExpMode;
	T48 ExpDays;
	T49 ExpHours;
	T50 ExpMinutes;
	T51 dExp; virtual _T51_ _dExp_(){return(_T51_)0;}
	T52 Slippage;
	T53 MyComment;
	T54 ArrowColorSell;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_SellNow()
	{
		Group = (string)"";
		Symbol = (string)CurrentSymbol();
		VolumeMode = (string)"fixed";
		VolumeSize = (double)0.1;
		VolumeSizeRisk = (double)50.0;
		VolumeRisk = (double)2.5;
		VolumePercent = (double)100.0;
		VolumeBlockPercent = (double)3.0;
		FixedRatioUnitSize = (double)0.01;
		FixedRatioDelta = (double)20.0;
		mmTradesPool = (int)0;
		mmMgInitialLots = (double)0.1;
		mmMgMultiplyOnLoss = (double)2.0;
		mmMgMultiplyOnProfit = (double)1.0;
		mmMgAddLotsOnLoss = (double)0.0;
		mmMgAddLotsOnProfit = (double)0.0;
		mmMgResetOnLoss = (int)0;
		mmMgResetOnProfit = (int)1;
		mm1326InitialLots = (double)0.1;
		mm1326Reverse = (bool)false;
		mmFiboInitialLots = (double)0.1;
		mmDalembertInitialLots = (double)0.1;
		mmDalembertReverse = (bool)false;
		mmLabouchereInitialLots = (double)0.1;
		mmLabouchereList = (string)"1,2,3,4,5,6";
		mmLabouchereReverse = (bool)false;
		mmSeqBaseLots = (double)0.1;
		mmSeqOnLoss = (string)"3,2,6";
		mmSeqOnProfit = (string)"1";
		mmSeqReverse = (bool)false;
		VolumeUpperLimit = (double)0.0;
		StopLossMode = (string)"fixed";
		StopLossPips = (double)50.0;
		StopLossPercentPrice = (double)0.55;
		StopLossPercentTP = (double)100.0;
		TakeProfitMode = (string)"fixed";
		TakeProfitPips = (double)50.0;
		TakeProfitPercentPrice = (double)0.55;
		TakeProfitPercentSL = (double)100.0;
		ExpMode = (string)"GTC";
		ExpDays = (int)0;
		ExpHours = (int)1;
		ExpMinutes = (int)0;
		Slippage = (ulong)4;
		MyComment = (string)"";
		ArrowColorSell = (color)clrRed;
	}

	public: /* The main method */
	virtual void _execute_()
	{
		//-- stops ------------------------------------------------------------------
		double sll = 0, slp = 0, tpl = 0, tpp = 0;
		
		     if (StopLossMode == "fixed")         {slp = StopLossPips;}
		else if (StopLossMode == "dynamicPips")   {slp = _dpStopLoss_();}
		else if (StopLossMode == "dynamicDigits") {slp = toPips(_ddStopLoss_(),Symbol);}
		else if (StopLossMode == "dynamicLevel")  {sll = _dlStopLoss_();}
		else if (StopLossMode == "percentPrice")  {sll = SymbolBid(Symbol) + (SymbolBid(Symbol) * StopLossPercentPrice / 100);}
		
		     if (TakeProfitMode == "fixed")         {tpp = TakeProfitPips;}
		else if (TakeProfitMode == "dynamicPips")   {tpp = _dpTakeProfit_();}
		else if (TakeProfitMode == "dynamicDigits") {tpp = toPips(_ddTakeProfit_(),Symbol);}
		else if (TakeProfitMode == "dynamicLevel")  {tpl = _dlTakeProfit_();}
		else if (TakeProfitMode == "percentPrice")  {tpl = SymbolBid(Symbol) - (SymbolBid(Symbol) * TakeProfitPercentPrice / 100);}
		
		if (StopLossMode == "percentTP") {
		   if (tpp > 0) {slp = tpp*StopLossPercentTP/100;}
		   if (tpl > 0) {slp = toPips(MathAbs(SymbolBid(Symbol) - tpl), Symbol)*StopLossPercentTP/100;}
		}
		if (TakeProfitMode == "percentSL") {
		   if (slp > 0) {tpp = slp*TakeProfitPercentSL/100;}
		   if (sll > 0) {tpp = toPips(MathAbs(SymbolBid(Symbol) - sll), Symbol)*TakeProfitPercentSL/100;}
		}
		
		//-- lots -------------------------------------------------------------------
		double lots = 0;
		double pre_sll = sll;
		
		if (pre_sll == 0) {
			pre_sll = SymbolBid(Symbol);
		}
		
		double pre_sl_pips = toPips((pre_sll+toDigits(slp,Symbol))-SymbolBid(Symbol), Symbol);
		
		     if (VolumeMode == "fixed")            {lots = DynamicLots(Symbol, VolumeMode, VolumeSize);}
		else if (VolumeMode == "block-equity")     {lots = DynamicLots(Symbol, VolumeMode, VolumeBlockPercent);}
		else if (VolumeMode == "block-balance")    {lots = DynamicLots(Symbol, VolumeMode, VolumeBlockPercent);}
		else if (VolumeMode == "block-freemargin") {lots = DynamicLots(Symbol, VolumeMode, VolumeBlockPercent);}
		else if (VolumeMode == "equity")           {lots = DynamicLots(Symbol, VolumeMode, VolumePercent);}
		else if (VolumeMode == "balance")          {lots = DynamicLots(Symbol, VolumeMode, VolumePercent);}
		else if (VolumeMode == "freemargin")       {lots = DynamicLots(Symbol, VolumeMode, VolumePercent);}
		else if (VolumeMode == "equityRisk")       {lots = DynamicLots(Symbol, VolumeMode, VolumeRisk, pre_sl_pips);}
		else if (VolumeMode == "balanceRisk")      {lots = DynamicLots(Symbol, VolumeMode, VolumeRisk, pre_sl_pips);}
		else if (VolumeMode == "freemarginRisk")   {lots = DynamicLots(Symbol, VolumeMode, VolumeRisk, pre_sl_pips);}
		else if (VolumeMode == "fixedRisk")        {lots = DynamicLots(Symbol, VolumeMode, VolumeSizeRisk, pre_sl_pips);}
		else if (VolumeMode == "fixedRatio")       {lots = DynamicLots(Symbol, VolumeMode, FixedRatioUnitSize, FixedRatioDelta);}
		else if (VolumeMode == "dynamic")          {lots = _dVolumeSize_();}
		else if (VolumeMode == "1326")             {lots = Bet1326(Group, Symbol, mmTradesPool, mm1326InitialLots, mm1326Reverse);}
		else if (VolumeMode == "fibonacci")        {lots = BetFibonacci(Group, Symbol, mmTradesPool, mmFiboInitialLots);}
		else if (VolumeMode == "dalembert")        {lots = BetDalembert(Group, Symbol, mmTradesPool, mmDalembertInitialLots, mmDalembertReverse);}
		else if (VolumeMode == "labouchere")       {lots = BetLabouchere(Group, Symbol, mmTradesPool, mmLabouchereInitialLots, mmLabouchereList, mmLabouchereReverse);}
		else if (VolumeMode == "martingale")       {lots = BetMartingale(Group, Symbol, mmTradesPool, mmMgInitialLots, mmMgMultiplyOnLoss, mmMgMultiplyOnProfit, mmMgAddLotsOnLoss, mmMgAddLotsOnProfit, mmMgResetOnLoss, mmMgResetOnProfit);}
		else if (VolumeMode == "sequence")         {lots = BetSequence(Group, Symbol, mmTradesPool, mmSeqBaseLots, mmSeqOnLoss, mmSeqOnProfit, mmSeqReverse);}
		
		lots = AlignLots(Symbol, lots, 0, VolumeUpperLimit);
		
		datetime exp = ExpirationTime(ExpMode,ExpDays,ExpHours,ExpMinutes,_dExp_());
		
		//-- send -------------------------------------------------------------------
		long ticket = SellNow(Symbol, lots, sll, tpl, slp, tpp, Slippage, (MagicStart+(int)Group), MyComment, ArrowColorSell, exp);
		
		if (ticket > 0) {_callback_(1);} else {_callback_(0);}
	}
};

// "close (partially)" model
template<typename T1,typename T2,typename T3,typename T4,typename T5>
class MDL_LoopClosePart: public BlockCalls
{
	public: /* Input Parameters */
	T1 PartVolMode;
	T2 PartVolLots;
	T3 PartVolPercent;
	T4 Slippage;
	T5 ArrowColor;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_LoopClosePart()
	{
		PartVolMode = (string)"percent";
		PartVolLots = (double)0.05;
		PartVolPercent = (double)50.0;
		Slippage = (ulong)4;
		ArrowColor = (color)clrDeepPink;
	}

	public: /* The main method */
	virtual void _execute_()
	{
		if (FXD_BREAK == true) {return;}
		
		LoopedResume();
		
		//-- lots to close ------------------------------------------------------------------------------------------
		double lots = 0;
		
		     if (PartVolMode == "fixed")            {lots = PartVolLots;}
		else if (PartVolMode == "percent")          {lots = (OrderLots()*PartVolPercent)/100;}
		else if (PartVolMode == "percent-initial")  {lots = (attrLotsInitial()*PartVolPercent)/100;}
		
		if (PartVolPercent > 100) {lots = OrderLots();}
		
		//-- partial close ------------------------------------------------------------------------------------------
		bool success = true;
		
		if (OrderType() < 2) {
			success = CloseTradePartial(OrderTicket(), lots, Slippage, ArrowColor);
		}
		
		if (success) {_callback_(1);} else {_callback_(0);}
	}
};

// "Custom MQL code" model
template<typename T1>
class MDL_CustomCode: public BlockCalls
{
	public: /* Input Parameters */
	T1 SourceCode;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_CustomCode()
	{
	}

	public: /* The main method */
	virtual void _execute_()
	{
		//_SourceCode_()
		
		_callback_(1);
	}
};

// "Pass" model
class MDL_Pass: public BlockCalls
{
	virtual void _callback_(int r) {return;}

	public: /* The main method */
	virtual void _execute_()
	{
		_callback_(1);
	}
};

// "Draw Edit Field" model
template<typename T1,typename T2,typename T3,typename T4,typename T5,typename T6,typename _T6_,typename T7,typename T8,typename T9,typename T10,typename T11,typename T12,typename T13,typename T14,typename T15,typename T16,typename T17,typename T18,typename T19,typename T20,typename T21,typename T22>
class MDL_ChartDrawEditField: public BlockCalls
{
	public: /* Input Parameters */
	T1 ObjectPerBar;
	T2 ObjectUpdate;
	T3 ObjName;
	T4 ObjX;
	T5 ObjY;
	T6 ObjText; virtual _T6_ _ObjText_(){return(_T6_)0;}
	T7 ObjFont;
	T8 ObjFontSize;
	T9 ObjAlign;
	T10 ObjXsize;
	T11 ObjYsize;
	T12 ObjBgColor;
	T13 ObjBorderColor;
	T14 ObjCorner;
	T15 ObjReadOnly;
	T16 ObjColor;
	T17 ObjBack;
	T18 ObjSelectable;
	T19 ObjSelected;
	T20 ObjHidden;
	T21 ObjZorder;
	T22 ObjChartSubWindow;
	/* Static Parameters */
	int count;
	datetime time0;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_ChartDrawEditField()
	{
		ObjectPerBar = (bool)false;
		ObjectUpdate = (bool)true;
		ObjName = (string)"";
		ObjX = (int)10;
		ObjY = (int)10;
		ObjFont = (string)"Arial";
		ObjFontSize = (int)10;
		ObjAlign = (int)ALIGN_CENTER;
		ObjXsize = (int)50;
		ObjYsize = (int)18;
		ObjBgColor = (color)clrWhite;
		ObjBorderColor = (color)clrNONE;
		ObjCorner = (int)CORNER_LEFT_UPPER;
		ObjReadOnly = (bool)false;
		ObjColor = (color)clrDeepPink;
		ObjBack = (bool)true;
		ObjSelectable = (bool)false;
		ObjSelected = (bool)false;
		ObjHidden = (bool)false;
		ObjZorder = (int)0;
		ObjChartSubWindow = (string)"";
		/* Static Parameters (initial value) */
		count =  0;
		time0 =  0;
	}

	public: /* The main method */
	virtual void _execute_()
	{
		string ObjNamePrefix = "fxd_edit_";
		long ObjChartID      = 0;
		int subwindow_id     = WindowFindVisible(ObjChartID, ObjChartSubWindow);
		
		if (subwindow_id >= 0)
		{
			string name       = "";
			string name_base  = "";
			bool get_new_name = false;
			bool do_update    = true;
		
			if (ObjectPerBar == true)
			{
				datetime time = iTime(Symbol(),0,1);
		
				if (time0 < time)
				{
					time0        = time;
					get_new_name = true;
				}
				else
				{
					if (ObjectUpdate == false) {do_update = false;}
				}
			}
			else
			{
				if (ObjectUpdate == false) {get_new_name = true;}
			}
		
			if (do_update)
			{
				if (ObjName != "") {name_base = ObjName;} else {name_base = ObjNamePrefix + __block_user_number + "_";}
		
				if (get_new_name == false)
				{
					name = name_base + IntegerToString(count);
				}
				else
				{
					while (true)
					{
						count++;
						name = name_base + IntegerToString(count);
		
						if (ObjectFind(ObjChartID,name) < 0) {break;}
					}
				}
		
				if (ObjName != "" && count == 0) {name = ObjName;}
		
				if (ObjectFind(ObjChartID,name) < 0 && !ObjectCreate(ObjChartID,name,OBJ_EDIT,subwindow_id,0,0))
				{
					Print(__FUNCTION__,": failed to create edit field object! Error code = ",GetLastError());
				}
		
				ObjectSetInteger(ObjChartID,name,OBJPROP_XDISTANCE,ObjX);
				ObjectSetInteger(ObjChartID,name,OBJPROP_YDISTANCE,ObjY);
				ObjectSetInteger(ObjChartID,name,OBJPROP_XSIZE,ObjXsize);
				ObjectSetInteger(ObjChartID,name,OBJPROP_YSIZE,ObjYsize);
				ObjectSetInteger(ObjChartID,name,OBJPROP_BGCOLOR,ObjBgColor);
				ObjectSetInteger(ObjChartID,name,OBJPROP_BORDER_COLOR,ObjBorderColor);
				ObjectSetInteger(ObjChartID,name,OBJPROP_CORNER,ObjCorner);
				ObjectSetInteger(ObjChartID,name,OBJPROP_READONLY,ObjReadOnly);
				ObjectSetInteger(ObjChartID,name,OBJPROP_ALIGN,ObjAlign);
				ObjectSetString(ObjChartID,name,OBJPROP_FONT,ObjFont);
				ObjectSetInteger(ObjChartID,name,OBJPROP_FONTSIZE,ObjFontSize);
				ObjectSetString(ObjChartID,name,OBJPROP_TEXT,(string)_ObjText_());
		
				//ObjectSetInteger(ObjChartID,name,OBJPROP_STYLE,ObjStyle);
				ObjectSetInteger(ObjChartID,name,OBJPROP_COLOR,ObjColor);
				ObjectSetInteger(ObjChartID,name,OBJPROP_BACK,ObjBack);
				//ObjectSetInteger(ObjChartID,name,OBJPROP_WIDTH,ObjWidth);
				ObjectSetInteger(ObjChartID,name,OBJPROP_SELECTABLE,ObjSelectable);
				ObjectSetInteger(ObjChartID,name,OBJPROP_SELECTED,ObjSelected);
				ObjectSetInteger(ObjChartID,name,OBJPROP_HIDDEN,ObjHidden);
				ObjectSetInteger(ObjChartID,name,OBJPROP_ZORDER,ObjZorder);
		
				ChartRedraw();
			}
		}
		
		_callback_(1);
	}
};

// "Formula" model
template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_>
class MDL_Formula_9: public BlockCalls
{
	public: /* Input Parameters */
	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;}
	T2 compare;
	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;}
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_Formula_9()
	{
		compare = (string)"+";
	}

	public: /* The main method */
	virtual void _execute_()
	{
		_T1_ lo = _Lo_();
		if (typename(_T1_) != "string" && MathAbs(lo) == EMPTY_VALUE) {return;}
		
		_T3_ ro = _Ro_();
		if (typename(_T3_) != "string" && MathAbs(ro) == EMPTY_VALUE) {return;}
		
		v::risk_percent = formula(compare, lo, ro);
		
		_callback_(1);
	}
};

// "Formula" model
template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_>
class MDL_Formula_10: public BlockCalls
{
	public: /* Input Parameters */
	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;}
	T2 compare;
	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;}
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_Formula_10()
	{
		compare = (string)"+";
	}

	public: /* The main method */
	virtual void _execute_()
	{
		_T1_ lo = _Lo_();
		if (typename(_T1_) != "string" && MathAbs(lo) == EMPTY_VALUE) {return;}
		
		_T3_ ro = _Ro_();
		if (typename(_T3_) != "string" && MathAbs(ro) == EMPTY_VALUE) {return;}
		
		v::risk_percent = formula(compare, lo, ro);
		
		_callback_(1);
	}
};

// "Edit Field modified" model
template<typename T1,typename T2>
class MDL_eChart_LabelEndModify: public BlockCalls
{
	public: /* Input Parameters */
	T1 NameFilterMode;
	T2 ObjName;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_eChart_LabelEndModify()
	{
		NameFilterMode = (string)"";
		ObjName = (string)"";
	}

	public: /* The main method */
	virtual void _execute_()
	{
		bool next = false;
		
		if (FXD_ONCHART.id == CHARTEVENT_OBJECT_ENDEDIT)
		{
			if (NameFilterMode == "name" || NameFilterMode == "names")
			{
				string names[];
		
				if (ObjName != "")
				{
					StringExplode(",", ObjName, names);
					int size = ArraySize(names);
		
					for (int i = 0; i < size; i++)
					{
						if (FXD_ONCHART.sparam == StringTrim(names[i]))
						{
							next = true;
							break;
						}
					}
				}
			}
			else
			{
				next = true;
			}
		}
		
		if (next == true) {_callback_(1);} else {_callback_(0);}
	}
};

// "Alert message" model
template<typename T1,typename T2,typename T3,typename _T3_,typename T4,typename T5,typename _T5_,typename T6,typename T7,typename _T7_,typename T8,typename T9,typename _T9_,typename T10,typename T11,typename _T11_,typename T12,typename T13,typename _T13_,typename T14,typename T15,typename _T15_,typename T16,typename T17,typename _T17_,typename T18,typename T19,typename _T19_,typename T20,typename T21,typename _T21_,typename T22>
class MDL_AlertMessageAdvanced: public BlockCalls
{
	public: /* Input Parameters */
	T1 AlertTitle;
	T2 AlertLabel1;
	T3 AlertValue1; virtual _T3_ _AlertValue1_(){return(_T3_)0;}
	T4 AlertLabel2;
	T5 AlertValue2; virtual _T5_ _AlertValue2_(){return(_T5_)0;}
	T6 AlertLabel3;
	T7 AlertValue3; virtual _T7_ _AlertValue3_(){return(_T7_)0;}
	T8 AlertLabel4;
	T9 AlertValue4; virtual _T9_ _AlertValue4_(){return(_T9_)0;}
	T10 AlertLabel5;
	T11 AlertValue5; virtual _T11_ _AlertValue5_(){return(_T11_)0;}
	T12 AlertLabel6;
	T13 AlertValue6; virtual _T13_ _AlertValue6_(){return(_T13_)0;}
	T14 AlertLabel7;
	T15 AlertValue7; virtual _T15_ _AlertValue7_(){return(_T15_)0;}
	T16 AlertLabel8;
	T17 AlertValue8; virtual _T17_ _AlertValue8_(){return(_T17_)0;}
	T18 AlertLabel9;
	T19 AlertValue9; virtual _T19_ _AlertValue9_(){return(_T19_)0;}
	T20 AlertLabel10;
	T21 AlertValue10; virtual _T21_ _AlertValue10_(){return(_T21_)0;}
	T22 AlsoSendNotification;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_AlertMessageAdvanced()
	{
		AlertTitle = (string)"Alert Message";
		AlertLabel1 = (string)"";
		AlertLabel2 = (string)"";
		AlertLabel3 = (string)"";
		AlertLabel4 = (string)"";
		AlertLabel5 = (string)"";
		AlertLabel6 = (string)"";
		AlertLabel7 = (string)"";
		AlertLabel8 = (string)"";
		AlertLabel9 = (string)"";
		AlertLabel10 = (string)"";
		AlsoSendNotification = (bool)false;
	}

	public: /* The main method */
	virtual void _execute_()
	{
		string text = "";
		
		if (AlertLabel1 != "") {text += "\n" + AlertLabel1 + ": " + (string)(_AlertValue1_());}
		if (AlertLabel2 != "") {text += "\n" + AlertLabel2 + ": " + (string)(_AlertValue2_());}
		if (AlertLabel3 != "") {text += "\n" + AlertLabel3 + ": " + (string)(_AlertValue3_());}
		if (AlertLabel4 != "") {text += "\n" + AlertLabel4 + ": " + (string)(_AlertValue4_());}
		if (AlertLabel5 != "") {text += "\n" + AlertLabel5 + ": " + (string)(_AlertValue5_());}
		if (AlertLabel6 != "") {text += "\n" + AlertLabel6 + ": " + (string)(_AlertValue6_());}
		if (AlertLabel7 != "") {text += "\n" + AlertLabel7 + ": " + (string)(_AlertValue7_());}
		if (AlertLabel8 != "") {text += "\n" + AlertLabel8 + ": " + (string)(_AlertValue8_());}
		if (AlertLabel9 != "") {text += "\n" + AlertLabel9 + ": " + (string)(_AlertValue9_());}
		if (AlertLabel10 != "") {text += "\n" + AlertLabel10 + ": " + (string)(_AlertValue10_());}
		
		text = AlertTitle + "\n" + text;
		
		Alert(text);
		
		if (AlsoSendNotification==true) SendNotification(text);
		
		_callback_(1);
	}
};

// "Close positions" model
template<typename T1,typename T2,typename T3,typename T4,typename T5,typename T6,typename T7,typename T8>
class MDL_CloseOpened: public BlockCalls
{
	public: /* Input Parameters */
	T1 GroupMode;
	T2 Group;
	T3 SymbolMode;
	T4 Symbol;
	T5 BuysOrSells;
	T6 OrderMinutes;
	T7 Slippage;
	T8 ArrowColor;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_CloseOpened()
	{
		GroupMode = (string)"group";
		Group = (string)"";
		SymbolMode = (string)"symbol";
		Symbol = (string)CurrentSymbol();
		BuysOrSells = (string)"both";
		OrderMinutes = (int)0;
		Slippage = (ulong)4;
		ArrowColor = (color)clrDeepPink;
	}

	public: /* The main method */
	virtual void _execute_()
	{
		int closed_count = 0;
		bool finished    = false;
		
		while (finished == false)
		{
			int count = 0;
		
			for (int index = TradesTotal()-1; index >= 0; index--)
			{
				if (TradeSelectByIndex(index, GroupMode, Group, SymbolMode, Symbol, BuysOrSells))
				{
					datetime time_diff = TimeCurrent() - OrderOpenTime();
		
					if (time_diff < 0) {time_diff = 0;} // this actually happens sometimes
		
					if (time_diff >= 60 * OrderMinutes)
					{
						if (CloseTrade(OrderTicket(), Slippage, ArrowColor))
						{
							closed_count++;
						}
		
						count++;
					}
				}
			}
		
			if (count == 0) {finished = true;}
		}
		
		_callback_(1);
	}
};

// "For each Position" model
template<typename T1,typename T2,typename T3,typename T4,typename T5,typename T6,typename T7,typename T8,typename T9,typename T10>
class MDL_LoopStartTrades: public BlockCalls
{
	public: /* Input Parameters */
	T1 GroupMode;
	T2 Group;
	T3 SymbolMode;
	T4 Symbol;
	T5 BuysOrSells;
	T6 LoopDirection;
	T7 LoopSkip;
	T8 LoopEvery;
	T9 LoopLimit;
	T10 PassEnd;
	/* Static Parameters */
	double trades[][2];
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_LoopStartTrades()
	{
		GroupMode = (string)"group";
		Group = (string)"";
		SymbolMode = (string)"symbol";
		Symbol = (string)CurrentSymbol();
		BuysOrSells = (string)"both";
		LoopDirection = (string)"newest-to-oldest";
		LoopSkip = (int)0;
		LoopEvery = (int)0;
		LoopLimit = (int)0;
		PassEnd = (int)0;
	}

	public: /* The main method */
	virtual void _execute_()
	{
		// used when sorting by profit
		
		int saved_type     = attrTypeInLoop();
		ulong saved_ticket = attrTicketInLoop(); // This ticket number will be reloaded at the end of this loop, so if we are in another overlapping loop - it will continue using it's last used ticket number
		
		int total = TradesTotal();
		int count = 0;
		int skip  = -1;
		int every = 0;
		
		bool get_from_array = false;
		
		int i_start = 0, i_stop = 0, i_inc = 0, i = 0;
		
		if (LoopDirection == "newest-to-oldest")
		{
			i_start = total-1;
			i_stop  = 0;
			i_inc   = -1;
		}
		else if (LoopDirection == "oldest-to-newest")
		{
		  	i_start = 0;
			i_stop  = total-1;
			i_inc   = 1;
		}
		else if (LoopDirection == "profitable-first" || LoopDirection == "profitable-last")
		{
			int last_index = -1;
			get_from_array = true;
			
			// Collect data
			ArrayResize(trades,0);
			int size = 0;
		
			for (int pos=0; pos < total; pos++)
			{
				if (!TradeSelectByIndex(pos, GroupMode, Group, SymbolMode, Symbol, BuysOrSells)) continue;
		
				size++;
				ArrayResize(trades,size);
		
				trades[size-1][0] = OrderProfit();
				trades[size-1][1] = (double)OrderTicket();
			}
		
			// Sort
			if (size > 0)
			{
				ArraySort(trades);
				last_index = size - 1;
			}
		
			// At this moment the array is sorted starting from the least profitable trade
		
			i_start = last_index;
			i_stop  = 0;
			i_inc   = -1;
			
			if (LoopDirection == "profitable-last")
			{
				i_start = 0;
				i_stop  = last_index;
				i_inc   = 1;
			}
		}
		
		i = i_start - i_inc;
		
		while (true)
		{
		  	if (i == i_stop) break;
		  	i = i + i_inc;
			
			// simulate break and continue functionality in loop blocks
			if (FXD_CONTINUE == true)
			{
				FXD_BREAK    = false;
				FXD_CONTINUE = false;
			}
			else if (FXD_BREAK == true)
			{
				FXD_BREAK    = false;
				FXD_CONTINUE = false;
				break;
			}
			
			if (get_from_array)
			{
				if (!TradeSelectByTicket((ulong)trades[i][1])) continue;
			}
			else
			{
				if (!TradeSelectByIndex(i, GroupMode, Group, SymbolMode, Symbol, BuysOrSells)) continue;
			}
		
			skip++;
		
			if (LoopSkip <= skip && (count < LoopLimit || LoopLimit == 0))
			{
				if (LoopEvery > 0)
				{
					every++;
		
					if (every < LoopEvery) {continue;} else {every = 0;}
				}
				
				count++;
				attrTypeInLoop(1);
				attrTicketInLoop(OrderTicket());
		
				_callback_(1);
				
				if (count == LoopLimit) break;
			}
			
			if (LoopDirection == "oldest-to-newest")
			{
				// if trade was closed meanwhile
				if (i_stop > TradesTotal()-1)
				{
					i_stop = TradesTotal()-1;
					i--;
				}
			}
		}
		
		attrTypeInLoop(saved_type);
		attrTicketInLoop(saved_ticket); // Reloading Ticket number from the overlapping loop (if any)
		
		FXD_BREAK    = false;
		FXD_CONTINUE = false;
		
		if (
			   (PassEnd == 0)
			|| (PassEnd == 1 && count > 0)
			|| (PassEnd == 2 && count == 0)
		) {
			_callback_(0);
		}
	}
};

// "Log message" model
template<typename T1>
class MDL_PrintMessage: public BlockCalls
{
	public: /* Input Parameters */
	T1 PrintText;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_PrintMessage()
	{
		PrintText = (string)"Enter your text here";
	}

	public: /* The main method */
	virtual void _execute_()
	{
		Print(PrintText);
		
		_callback_(1);
	}
};

// "Formula" model
template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_>
class MDL_Formula_11: public BlockCalls
{
	public: /* Input Parameters */
	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;}
	T2 compare;
	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;}
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_Formula_11()
	{
		compare = (string)"+";
	}

	public: /* The main method */
	virtual void _execute_()
	{
		_T1_ lo = _Lo_();
		if (typename(_T1_) != "string" && MathAbs(lo) == EMPTY_VALUE) {return;}
		
		_T3_ ro = _Ro_();
		if (typename(_T3_) != "string" && MathAbs(ro) == EMPTY_VALUE) {return;}
		
		v::rf_div = formula(compare, lo, ro)*100;
		
		_callback_(1);
	}
};

// "check type" model
template<typename T1,typename T2>
class MDL_LoopCheckType: public BlockCalls
{
	public: /* Input Parameters */
	T1 CheckBuyOrSell;
	T2 CheckLimitOrStop;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_LoopCheckType()
	{
		CheckBuyOrSell = (string)"buy";
		CheckLimitOrStop = (string)"both";
	}

	public: /* The main method */
	virtual void _execute_()
	{
		if (FXD_BREAK == true) {return;}
		
		LoopedResume();
		
		if (
			   (CheckBuyOrSell == "both" || (CheckBuyOrSell == "buy" && IsOrderTypeBuy()) || (CheckBuyOrSell == "sell" && IsOrderTypeSell()))
			&& (CheckLimitOrStop == "both" || (CheckLimitOrStop == "buy" && IsOrderTypeStop()) || (CheckLimitOrStop == "sell" && IsOrderTypeStop()))
		) {_callback_(1);} else {_callback_(0);}
	}
};

// "If position/order" model
template<typename T1,typename T2,typename T3,typename T4,typename T5>
class MDL_IfOrders: public BlockCalls
{
	public: /* Input Parameters */
	T1 GroupMode;
	T2 Group;
	T3 SymbolMode;
	T4 Symbol;
	T5 BuysOrSells;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_IfOrders()
	{
		GroupMode = (string)"group";
		Group = (string)"";
		SymbolMode = (string)"symbol";
		Symbol = (string)CurrentSymbol();
		BuysOrSells = (string)"both";
	}

	public: /* The main method */
	virtual void _execute_()
	{
		bool exist = false;
		
		for (int index = TradesTotal()-1; index >= 0; index--)
		{
			if (TradeSelectByIndex(index, GroupMode, Group, SymbolMode, Symbol, BuysOrSells))
			{
				exist = true;
				break;
			}
		}
		
		if (exist == false)
		{
			for (int index = OrdersTotal()-1; index >= 0; index--)
			{
				if (PendingOrderSelectByIndex(index, GroupMode, Group, SymbolMode, Symbol, BuysOrSells))
				{
					exist = true;
					break;
				}
			}
		}
		
		if (exist == true) {_callback_(1);} else {_callback_(0);}
	}
};

// "Set Flag (true-false)" model
template<typename T1,typename T2>
class MDL_FlagSetB: public BlockCalls
{
	public: /* Input Parameters */
	T1 FlagName;
	T2 FlagValue;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_FlagSetB()
	{
		FlagName = (string)"MyFlag";
		FlagValue = (bool)true;
	}

	public: /* The main method */
	virtual void _execute_()
	{
		SetFlagB(FlagName,FlagValue);
		
		_callback_(1);
	}
};

// "Check Flag (true-false)" model
template<typename T1,typename T2>
class MDL_FlagCheckB: public BlockCalls
{
	public: /* Input Parameters */
	T1 FlagName;
	T2 FlagValue;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_FlagCheckB()
	{
		FlagName = (string)"MyFlag";
		FlagValue = (bool)true;
	}

	public: /* The main method */
	virtual void _execute_()
	{
		if (GetFlagB(FlagName) == FlagValue) {_callback_(1);} else {_callback_(0);}
	}
};

// "Set Flag (textual)" model
template<typename T1,typename T2>
class MDL_FlagSetT: public BlockCalls
{
	public: /* Input Parameters */
	T1 FlagName;
	T2 FlagValue;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_FlagSetT()
	{
		FlagName = (string)"MyFlag";
		FlagValue = (string)"";
	}

	public: /* The main method */
	virtual void _execute_()
	{
		SetFlagT(FlagName,FlagValue);
		
		_callback_(1);
	}
};

// "Check Flag (textual)" model
template<typename T1,typename T2>
class MDL_FlagCheckT: public BlockCalls
{
	public: /* Input Parameters */
	T1 FlagName;
	T2 FlagValue;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_FlagCheckT()
	{
		FlagName = (string)"MyFlag";
		FlagValue = (string)"";
	}

	public: /* The main method */
	virtual void _execute_()
	{
		if (GetFlagT(FlagName) == FlagValue) {_callback_(1);} else {_callback_(0);}
	}
};

// "modify stops" model
template<typename T1,typename T2,typename _T2_,typename T3,typename T4,typename T5,typename T6,typename T7,typename T8,typename _T8_,typename T9,typename _T9_,typename T10,typename _T10_,typename T11,typename T12,typename T13,typename T14,typename T15,typename T16,typename _T16_,typename T17,typename _T17_,typename T18,typename _T18_,typename T19>
class MDL_LoopModifySLTP: public BlockCalls
{
	public: /* Input Parameters */
	T1 RelativeTo;
	T2 dPrice; virtual _T2_ _dPrice_(){return(_T2_)0;}
	T3 NewSLmode;
	T4 NewStopLoss;
	T5 NewStopLossPercentPrice;
	T6 NewStopLossPercent;
	T7 NewStopLossPercentTP;
	T8 fNewStopLoss; virtual _T8_ _fNewStopLoss_(){return(_T8_)0;}
	T9 dpNewStopLoss; virtual _T9_ _dpNewStopLoss_(){return(_T9_)0;}
	T10 ddNewStopLoss; virtual _T10_ _ddNewStopLoss_(){return(_T10_)0;}
	T11 NewTPmode;
	T12 NewTakeProfit;
	T13 NewTakeProfitPercentPrice;
	T14 NewTakeProfitPercent;
	T15 NewTakeProfitPercentSL;
	T16 fNewTakeProfit; virtual _T16_ _fNewTakeProfit_(){return(_T16_)0;}
	T17 dpNewTakeProfit; virtual _T17_ _dpNewTakeProfit_(){return(_T17_)0;}
	T18 ddNewTakeProfit; virtual _T18_ _ddNewTakeProfit_(){return(_T18_)0;}
	T19 LevelColor;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_LoopModifySLTP()
	{
		RelativeTo = (string)"openprice";
		NewSLmode = (string)"fixed";
		NewStopLoss = (double)50.0;
		NewStopLossPercentPrice = (double)0.55;
		NewStopLossPercent = (double)50.0;
		NewStopLossPercentTP = (double)50.0;
		NewTPmode = (string)"fixed";
		NewTakeProfit = (double)50.0;
		NewTakeProfitPercentPrice = (double)0.55;
		NewTakeProfitPercent = (double)50.0;
		NewTakeProfitPercentSL = (double)50.0;
		LevelColor = (color)clrDeepPink;
	}

	public: /* The main method */
	virtual void _execute_()
	{
		if (FXD_BREAK == true) {return;}
		
		LoopedResume();
		
		string symbol = OrderSymbol();
		int digits    = (int)SymbolInfoInteger(symbol, SYMBOL_DIGITS);
		int polarity  = (IsOrderTypeBuy()) ? 1 : -1;
		double price  = (IsOrderTypeBuy()) ? SymbolAsk(symbol) : SymbolBid(symbol);
		
		//-- New Price level ------------------------------------------------------------------------------------------------------------------------     
		     if (RelativeTo == "openprice") {price = OrderOpenPrice();}
		else if (RelativeTo == "dynamic")   {price = _dPrice_();}
		else if (RelativeTo == "current-reverse")
		{
			price = (IsOrderTypeBuy()) ? SymbolBid(symbol) : SymbolAsk(symbol);
		}
		
		//-- Stop Loss and Take Profit --------------------------------------------------------------------------------------------------------------
		double oldSL = NormalizeDouble(attrStopLoss(), digits);
		double oldTP = NormalizeDouble(attrTakeProfit(), digits);
		double SL = oldSL;
		double TP = oldTP;
		
		     if (NewSLmode == "fixed")        {SL = (NewStopLoss == 0.0) ? 0.0 : price - (polarity * toDigits(NewStopLoss, symbol));}
		else if (NewSLmode == "percentPrice") {SL = (NewStopLossPercentPrice == 0.0) ? 0.0 : price - (polarity * price * NewStopLossPercentPrice / 100);}
		else if (NewSLmode == "percent")      {SL = (NewStopLossPercent == 0.0) ? 0.0 : price - (polarity * MathAbs(price-oldSL)*NewStopLossPercent/100);}
		else if (NewSLmode == "percentTP")    {SL = (NewStopLossPercentTP == 0.0) ? 0.0 : price - (polarity * MathAbs(price-oldTP)*NewStopLossPercentTP/100);}
		else if (NewSLmode == "function")     {SL = _fNewStopLoss_();}
		else if (NewSLmode == "dynamicPips")
		{
		   SL = toDigits(_dpNewStopLoss_(), symbol);
			SL = (SL == 0.0) ? 0.0 : price - (polarity * SL);
		}
		else if (NewSLmode == "dynamicDigits")
		{
			SL = _ddNewStopLoss_();
			SL = (SL == 0.0) ? 0.0 : price - (polarity * SL);
		}
		
		     if (NewTPmode == "fixed")        {TP = (NewTakeProfit == 0.0) ? 0.0 : price + (polarity * toDigits(NewTakeProfit, symbol));}
		else if (NewSLmode == "percentPrice") {TP = (NewTakeProfitPercentPrice == 0.0) ? 0.0 : price + (polarity * price * NewTakeProfitPercentPrice / 100);}
		else if (NewTPmode == "percent")      {TP = (NewTakeProfitPercent == 0.0) ? 0.0 : price + (polarity * MathAbs(price-oldTP)*NewTakeProfitPercent/100);}
		else if (NewTPmode == "percentSL")    {TP = (NewTakeProfitPercentSL == 0.0) ? 0.0 : price + (polarity * MathAbs(price-oldSL)*NewTakeProfitPercentSL/100);}
		else if (NewTPmode == "function")     {TP = _fNewTakeProfit_();}
		else if (NewTPmode == "dynamicPips")
		{
			TP = toDigits(_dpNewTakeProfit_(), symbol);
			TP = (TP == 0.0) ? 0.0 : price + (polarity * TP);
		}
		else if (NewTPmode == "dynamicDigits")
		{
			TP = _ddNewTakeProfit_();
			TP = (TP == 0.0) ? 0.0 : price + (polarity * TP);
		}
		
		//-- Send -----------------------------------------------------------------------------------------------------------------------------------
		bool success = false;
		
		if (SL != oldSL || TP != oldTP)
		{
		   success = ModifyOrder(OrderTicket(), OrderOpenPrice(), SL, TP, 0, 0, OrderExpirationTime(), LevelColor);
		}
		
		if (success == true) {_callback_(1);} else {_callback_(0);}
	}
};

// "Formula" model
template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_>
class MDL_Formula_12: public BlockCalls
{
	public: /* Input Parameters */
	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;}
	T2 compare;
	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;}
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_Formula_12()
	{
		compare = (string)"+";
	}

	public: /* The main method */
	virtual void _execute_()
	{
		_T1_ lo = _Lo_();
		if (typename(_T1_) != "string" && MathAbs(lo) == EMPTY_VALUE) {return;}
		
		_T3_ ro = _Ro_();
		if (typename(_T3_) != "string" && MathAbs(ro) == EMPTY_VALUE) {return;}
		
		v::rf_div = formula(compare, lo, ro)*100;
		
		_callback_(1);
	}
};

// "Position closed" model
template<typename T1,typename T2,typename T3,typename T4,typename T5,typename T6,typename T7>
class MDL_eTrade_TradeClosed: public BlockCalls
{
	public: /* Input Parameters */
	T1 GroupMode;
	T2 Group;
	T3 SymbolMode;
	T4 Symbol;
	T5 BuysOrSells;
	T6 CloseMode;
	T7 ClosePartialMode;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_eTrade_TradeClosed()
	{
		GroupMode = (string)"group";
		Group = (string)"";
		SymbolMode = (string)"symbol";
		Symbol = (string)CurrentSymbol();
		BuysOrSells = (string)"both";
		CloseMode = (string)"";
		ClosePartialMode = (int)0;
	}

	public: /* The main method */
	virtual void _execute_()
	{
		bool next = false;
		
		if (
			   (e_Reason() == "close" || e_Reason() == "decrement")
			&& e_attrType() < 2
			&& FilterEventTrade(GroupMode, Group, SymbolMode, Symbol, BuysOrSells)
		)
		{
			string closedBy = e_ReasonDetail();
		
			if (
				(
						(CloseMode == "")
					|| (CloseMode == closedBy)
					|| (CloseMode == "sltp" && (closedBy == "sl" || closedBy == "tp"))
					|| (CloseMode == "nosltp" && (closedBy != "sl" && closedBy != "tp"))
					|| (CloseMode == "exp" && closedBy == "expiration")
				)
				&& (
					   (ClosePartialMode == 0)
					|| (ClosePartialMode == 1 && e_Reason() == "close") // fully closed
					|| (ClosePartialMode == 2 && e_Reason() == "decrement") // partially closed
				)
			)
			{next = true;}
		}
		
		if (next) {_callback_(1);} else {_callback_(0);}
	}
};

// "No position" model
template<typename T1,typename T2,typename T3,typename T4,typename T5>
class MDL_NoOpenedOrders: public BlockCalls
{
	public: /* Input Parameters */
	T1 GroupMode;
	T2 Group;
	T3 SymbolMode;
	T4 Symbol;
	T5 BuysOrSells;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_NoOpenedOrders()
	{
		GroupMode = (string)"group";
		Group = (string)"";
		SymbolMode = (string)"symbol";
		Symbol = (string)CurrentSymbol();
		BuysOrSells = (string)"both";
	}

	public: /* The main method */
	virtual void _execute_()
	{
		bool exist = false;
		
		for (int index = TradesTotal()-1; index >= 0; index--)
		{
			if (TradeSelectByIndex(index, GroupMode, Group, SymbolMode, Symbol, BuysOrSells))
			{
				exist = true;
				break;
			}
		}
		
		if (exist == false) {_callback_(1);} else {_callback_(0);}
	}
};

// "Formula" model
template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_>
class MDL_Formula_13: public BlockCalls
{
	public: /* Input Parameters */
	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;}
	T2 compare;
	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;}
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_Formula_13()
	{
		compare = (string)"+";
	}

	public: /* The main method */
	virtual void _execute_()
	{
		_T1_ lo = _Lo_();
		if (typename(_T1_) != "string" && MathAbs(lo) == EMPTY_VALUE) {return;}
		
		_T3_ ro = _Ro_();
		if (typename(_T3_) != "string" && MathAbs(ro) == EMPTY_VALUE) {return;}
		
		v::pending_distance_pip = formula(compare, lo, ro);
		
		_callback_(1);
	}
};

// "Formula" model
template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_>
class MDL_Formula_14: public BlockCalls
{
	public: /* Input Parameters */
	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;}
	T2 compare;
	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;}
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_Formula_14()
	{
		compare = (string)"+";
	}

	public: /* The main method */
	virtual void _execute_()
	{
		_T1_ lo = _Lo_();
		if (typename(_T1_) != "string" && MathAbs(lo) == EMPTY_VALUE) {return;}
		
		_T3_ ro = _Ro_();
		if (typename(_T3_) != "string" && MathAbs(ro) == EMPTY_VALUE) {return;}
		
		v::pending_distance_pip = formula(compare, lo, ro);
		
		_callback_(1);
	}
};

// "Formula" model
template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_>
class MDL_Formula_15: public BlockCalls
{
	public: /* Input Parameters */
	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;}
	T2 compare;
	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;}
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_Formula_15()
	{
		compare = (string)"+";
	}

	public: /* The main method */
	virtual void _execute_()
	{
		_T1_ lo = _Lo_();
		if (typename(_T1_) != "string" && MathAbs(lo) == EMPTY_VALUE) {return;}
		
		_T3_ ro = _Ro_();
		if (typename(_T3_) != "string" && MathAbs(ro) == EMPTY_VALUE) {return;}
		
		v::rf_div = formula(compare, lo, ro);
		
		_callback_(1);
	}
};

// "Formula" model
template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_>
class MDL_Formula_16: public BlockCalls
{
	public: /* Input Parameters */
	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;}
	T2 compare;
	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;}
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDL_Formula_16()
	{
		compare = (string)"+";
	}

	public: /* The main method */
	virtual void _execute_()
	{
		_T1_ lo = _Lo_();
		if (typename(_T1_) != "string" && MathAbs(lo) == EMPTY_VALUE) {return;}
		
		_T3_ ro = _Ro_();
		if (typename(_T3_) != "string" && MathAbs(ro) == EMPTY_VALUE) {return;}
		
		v::rf_div = formula(compare, lo, ro);
		
		_callback_(1);
	}
};


//------------------------------------------------------------------------------------------------------------------------

// "Time" model
class MDLIC_value_time
{
	public: /* Input Parameters */
	int ModeTime;
	int TimeSource;
	string TimeStamp;
	int TimeCandleID;
	string TimeMarket;
	ENUM_TIMEFRAMES TimeCandleTimeframe;
	int TimeComponentYear;
	int TimeComponentMonth;
	double TimeComponentDay;
	double TimeComponentHour;
	double TimeComponentMinute;
	int TimeComponentSecond;
	datetime TimeValue;
	int ModeTimeShift;
	int TimeShiftYears;
	int TimeShiftMonths;
	int TimeShiftWeeks;
	double TimeShiftDays;
	double TimeShiftHours;
	double TimeShiftMinutes;
	int TimeShiftSeconds;
	bool TimeSkipWeekdays;
	/* Static Parameters */
	datetime retval;
	datetime retval0;
	datetime Time[];
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDLIC_value_time()
	{
		ModeTime = (int)0;
		TimeSource = (int)0;
		TimeStamp = (string)"00:00";
		TimeCandleID = (int)1;
		TimeMarket = (string)"";
		TimeCandleTimeframe = (ENUM_TIMEFRAMES)0;
		TimeComponentYear = (int)0;
		TimeComponentMonth = (int)0;
		TimeComponentDay = (double)0.0;
		TimeComponentHour = (double)12.0;
		TimeComponentMinute = (double)0.0;
		TimeComponentSecond = (int)0;
		TimeValue = (datetime)0;
		ModeTimeShift = (int)0;
		TimeShiftYears = (int)0;
		TimeShiftMonths = (int)0;
		TimeShiftWeeks = (int)0;
		TimeShiftDays = (double)0.0;
		TimeShiftHours = (double)0.0;
		TimeShiftMinutes = (double)0.0;
		TimeShiftSeconds = (int)0;
		TimeSkipWeekdays = (bool)false;
		/* Static Parameters (initial value) */
		retval =  0;
		retval0 =  0;
	}

	public: /* The main method */
	datetime _execute_()
	{
		// this is static for speed reasons
		
		if (TimeMarket == "") TimeMarket = Symbol();
		
		if (ModeTime == 0)
		{
			     if (TimeSource == 0) {retval = TimeCurrent();}
			else if (TimeSource == 1) {retval = TimeLocal() + (TimeCurrent() - TimeLocal());}
			else if (TimeSource == 2) {retval = TimeGMT() + (TimeCurrent() - TimeGMT());}
		}
		else if (ModeTime == 1)
		{
			retval  = StringToTime(TimeStamp);
			retval0 = retval;
		}
		else if (ModeTime==2)
		{
			retval = TimeFromComponents(TimeSource, TimeComponentYear, TimeComponentMonth, TimeComponentDay, TimeComponentHour, TimeComponentMinute, TimeComponentSecond);
		}
		else if (ModeTime == 3)
		{
			ArraySetAsSeries(Time,true);
			CopyTime(TimeMarket,TimeCandleTimeframe,TimeCandleID,1,Time);
			retval = Time[0];
		}
		else if (ModeTime == 4)
		{
			retval = TimeValue;
		}
		
		if (ModeTimeShift > 0)
		{
			int sh = 1;
		
			if (ModeTimeShift == 1) {sh = -1;}
		
			if (TimeShiftYears > 0 || TimeShiftMonths > 0)
			{
				int year = 0, month = 0, week = 0, day = 0, hour = 0, minute = 0, second = 0;
		
				if (ModeTime == 3)
				{
					year   = TimeComponentYear;
					month  = TimeComponentYear;
					day    = (int)MathFloor(TimeComponentDay);
					hour   = (int)(MathFloor(TimeComponentHour) + (24 * (TimeComponentDay - MathFloor(TimeComponentDay))));
					minute = (int)(MathFloor(TimeComponentMinute) + (60 * (TimeComponentHour - MathFloor(TimeComponentHour))));
					second = (int)(TimeComponentSecond + (60 * (TimeComponentMinute - MathFloor(TimeComponentMinute))));
				}
				else {
					year   = TimeYear(retval);
					month  = TimeMonth(retval);
					day    = TimeDay(retval);
					hour   = TimeHour(retval);
					minute = TimeMinute(retval);
					second = TimeSeconds(retval);
				}
		
				year  = year + TimeShiftYears * sh;
				month = month + TimeShiftMonths * sh;
		
				if (month < 0) {month = 12 - month;}
				else if (month > 12) {month = month - 12;}
		
				retval = StringToTime(IntegerToString(year)+"."+IntegerToString(month)+"."+IntegerToString(day)+" "+IntegerToString(hour)+":"+IntegerToString(minute)+":"+IntegerToString(second));
			}
		
			retval = retval + (sh * ((604800 * TimeShiftWeeks) + SecondsFromComponents(TimeShiftDays, TimeShiftHours, TimeShiftMinutes, TimeShiftSeconds)));
		
			if (TimeSkipWeekdays == true)
			{
				int weekday = TimeDayOfWeek(retval);
		
				if (sh > 0) { // forward
					     if (weekday == 0) {retval = retval + 86400;}
					else if (weekday == 6) {retval = retval + 172800;}
				}
				else if (sh < 0) { // back
					     if (weekday == 0) {retval = retval - 172800;}
					else if (weekday == 6) {retval = retval - 86400;}
				}
			}
		}
		
		
		return (datetime)retval;
	}
};

// "Lowest Price (Candles period)" model
class MDLIC_prices_LowestFromToCandles
{
	public: /* Input Parameters */
	int StartBar;
	int EndBar;
	int WhatToGet;
	string Symbol;
	ENUM_TIMEFRAMES Period;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDLIC_prices_LowestFromToCandles()
	{
		StartBar = (int)0;
		EndBar = (int)10;
		WhatToGet = (int)1;
		Symbol = (string)CurrentSymbol();
		Period = (ENUM_TIMEFRAMES)CurrentTimeframe();
	}

	public: /* The main method */
	double _execute_()
	{
		return LowestFromTo(Symbol,Period,StartBar,EndBar,WhatToGet);
	}
};

// "Candle" model
class MDLIC_candles_candles
{
	public: /* Input Parameters */
	string iOHLC;
	string ModeCandleFindBy;
	int CandleID;
	string TimeStamp;
	string Symbol;
	ENUM_TIMEFRAMES Period;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDLIC_candles_candles()
	{
		iOHLC = (string)"iClose";
		ModeCandleFindBy = (string)"id";
		CandleID = (int)0;
		TimeStamp = (string)"00:00";
		Symbol = (string)CurrentSymbol();
		Period = (ENUM_TIMEFRAMES)CurrentTimeframe();
	}

	public: /* The main method */
	double _execute_()
	{
		int digits = (int)SymbolInfoInteger(Symbol, SYMBOL_DIGITS);
		
		double O[];
		double H[];
		double L[];
		double C[]; 
		long cTickVolume[];
		long cRealVolume[];
		datetime T[];
		
		double retval = EMPTY_VALUE;
		
		// candle's id will change, so we don't want to mess with the variable CandleID;
		int cID = CandleID;
		
		if (ModeCandleFindBy == "time")
		{
			cID = iCandleID(Symbol, Period, StringToTimeEx(TimeStamp, "server"));
		}
		
		cID = cID + FXD_MORE_SHIFT;
		
		//-- the common levels ----------------------------------------------------
		if (iOHLC == "iOpen")
		{
			if (CopyOpen(Symbol,Period,cID,1,O) > -1) retval = O[0];
		}
		else if (iOHLC == "iHigh")
		{
			if (CopyHigh(Symbol,Period,cID,1,H) > -1) retval = H[0];
		}
		else if (iOHLC == "iLow")
		{
			if (CopyLow(Symbol,Period,cID,1,L) > -1) retval = L[0];
		}
		else if (iOHLC == "iClose")
		{
			if (CopyClose(Symbol,Period,cID,1,C) > -1) retval = C[0];
		}
		
		//-- non-price values  ----------------------------------------------------
		else if (iOHLC == "iVolume" || iOHLC == "iTickVolume")
		{
			if (CopyTickVolume(Symbol,Period,cID,1,cTickVolume) > -1) retval = (double)cTickVolume[0];
			
			return retval;
		}
		else if (iOHLC == "iRealVolume")
		{
			if (CopyRealVolume(Symbol,Period,cID,1,cRealVolume) > -1) retval = (double)cRealVolume[0];
			
			return retval;
		}
		else if (iOHLC == "iTime")
		{
			if (CopyTime(Symbol,Period,cID,1,T) > -1) retval = (double)T[0];
			
			return retval;
		}
		
		//-- simple calculations --------------------------------------------------
		else if (iOHLC == "iMedian")
		{
			if (
				   CopyLow(Symbol,Period,cID,1,L) > -1
				&& CopyHigh(Symbol,Period,cID,1,H) > -1
			)
			{
				retval = ((L[0]+H[0])/2);
			}
		}
		else if (iOHLC == "iTypical")
		{
			if (
				   CopyLow(Symbol,Period,cID,1,L) > -1
				&& CopyHigh(Symbol,Period,cID,1,H) > -1
				&& CopyClose(Symbol,Period,cID,1,C) > -1
			)
			{
				retval = ((L[0]+H[0]+C[0])/3);
			}
		}
		else if (iOHLC == "iAverage")
		{
			if (
				   CopyLow(Symbol,Period,cID,1,L) > -1
				&& CopyHigh(Symbol,Period,cID,1,H) > -1
				&& CopyClose(Symbol,Period,cID,1,C) > -1
			)
			{
				retval = ((L[0]+H[0]+C[0]+C[0])/4);
			}
		}
		
		//-- more complex levels --------------------------------------------------
		else if (iOHLC=="iTotal")
		{
			if (
				   CopyHigh(Symbol,Period,cID,1,H) > -1
				&& CopyLow(Symbol,Period,cID,1,L) > -1
			)
			{
				retval = toPips(MathAbs(H[0]-L[0]),Symbol);
			}
		}
		else if (iOHLC == "iBody")
		{
			if (
				   CopyOpen(Symbol,Period,cID,1,O) > -1
				&& CopyClose(Symbol,Period,cID,1,C) > -1
			)
			{
				retval = toPips(MathAbs(C[0]-O[0]),Symbol);
			}
		}
		else if (iOHLC == "iUpperWick")
		{
			if (
				   CopyHigh(Symbol,Period,cID,1,H) > -1
				&& CopyOpen(Symbol,Period,cID,1,O) > -1
				&& CopyClose(Symbol,Period,cID,1,C) > -1
				&& CopyLow(Symbol,Period,cID,1,L) > -1
			)
			{
				retval = (C[0] > O[0]) ? toPips(MathAbs(H[0]-C[0]),Symbol) : toPips(MathAbs(H[0]-O[0]),Symbol);
			}
		}
		else if (iOHLC == "iBottomWick")
		{
			if (
				   CopyHigh(Symbol,Period,cID,1,H) > -1
				&& CopyOpen(Symbol,Period,cID,1,O) > -1
				&& CopyClose(Symbol,Period,cID,1,C) > -1
				&& CopyLow(Symbol,Period,cID,1,L) > -1
			)
			{
				retval = (C[0] > O[0]) ? toPips(MathAbs(O[0]-L[0]),Symbol) : toPips(MathAbs(C[0]-L[0]),Symbol);
			}
		}
		else if (iOHLC == "iGap")
		{
			if (
				   CopyOpen(Symbol,Period,cID,1,O) > -1
				&& CopyClose(Symbol,Period,cID+1,1,C) > -1
			)
			{
				retval = toPips(MathAbs(O[0]-C[0]),Symbol);
			}
		}
		else if (iOHLC == "iBullTotal")
		{
			if (
				   CopyOpen(Symbol,Period,cID,1,O) > -1
				&& CopyClose(Symbol,Period,cID,1,C) > -1
				&& CopyHigh(Symbol,Period,cID,1,H) > -1
				&& CopyLow(Symbol,Period,cID,1,L) > -1
				&& C[0] > O[0]
			)
			{
				retval = toPips((H[0]-L[0]),Symbol);
			}
		}
		else if (iOHLC == "iBullBody")
		{
			if (
				   CopyOpen(Symbol,Period,cID,1,O) > -1
				&& CopyClose(Symbol,Period,cID,1,C) > -1
				&& C[0] > O[0]
			)
			{
				retval = toPips((C[0]-O[0]),Symbol);
			}
		}
		else if (iOHLC == "iBullUpperWick")
		{
			if (
				   CopyHigh(Symbol,Period,cID,1,H) > -1
				&& CopyOpen(Symbol,Period,cID,1,O) > -1
				&& CopyClose(Symbol,Period,cID,1,C) > -1
				&& C[0] > O[0]
			)
			{
				retval = toPips((H[0]-C[0]),Symbol);
			}
		}
		else if (iOHLC == "iBullBottomWick")
		{
			if (
				   CopyLow(Symbol,Period,cID,1,L) > -1
				&& CopyOpen(Symbol,Period,cID,1,O) > -1
				&& CopyClose(Symbol,Period,cID,1,C) > -1
				&& C[0] > O[0]
			)
			{
				retval = toPips((O[0]-L[0]),Symbol);
			}
		}
		else if (iOHLC == "iBearTotal")
		{
			if (
				   CopyOpen(Symbol,Period,cID,1,O) > -1
				&& CopyClose(Symbol,Period,cID,1,C) > -1
				&& CopyHigh(Symbol,Period,cID,1,H) > -1
				&& CopyLow(Symbol,Period,cID,1,L) > -1
				&& C[0] < O[0]
			)
			{
				retval = toPips((H[0]-L[0]),Symbol);
			}
		}
		else if (iOHLC == "iBearBody")
		{
			if (
				   CopyOpen(Symbol,Period,cID,1,O) > -1
				&& CopyClose(Symbol,Period,cID,1,C) > -1
				&& C[0] < O[0]
			)
			{
				retval = toPips((O[0]-C[0]),Symbol);
			}
		}
		else if (iOHLC == "iBearUpperWick")
		{
			if (
				   CopyHigh(Symbol,Period,cID,1,H) > -1
				&& CopyOpen(Symbol,Period,cID,1,O) > -1
				&& CopyClose(Symbol,Period,cID,1,C) > -1
				&& C[0] < O[0]
			)
			{
				retval = toPips((H[0]-O[0]),Symbol);
			}
		}
		else if (iOHLC == "iBearBottomWick")
		{
			if (
				   CopyLow(Symbol,Period,cID,1,L) > -1
				&& CopyOpen(Symbol,Period,cID,1,O) > -1
				&& CopyClose(Symbol,Period,cID,1,C) > -1
				&& C[0] < O[0]
			)
			{
				retval = toPips((C[0]-L[0]),Symbol);
			}
		}
		
		return NormalizeDouble(retval, digits);
	}
};

// "Highest Price (Candles period)" model
class MDLIC_prices_HighestFromToCandles
{
	public: /* Input Parameters */
	int StartBar;
	int EndBar;
	int WhatToGet;
	string Symbol;
	ENUM_TIMEFRAMES Period;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDLIC_prices_HighestFromToCandles()
	{
		StartBar = (int)0;
		EndBar = (int)10;
		WhatToGet = (int)1;
		Symbol = (string)CurrentSymbol();
		Period = (ENUM_TIMEFRAMES)CurrentTimeframe();
	}

	public: /* The main method */
	double _execute_()
	{
		return HighestFromTo(Symbol,Period,StartBar,EndBar,WhatToGet);
	}
};

// "Attributes set 1 (numeric)" model
class MDLIC_objectattributes_OBJECT
{
	public: /* Input Parameters */
	string ObjSource;
	string Name;
	int Property;
	int FiboLevelID;
	double TLpriceLevel;
	int Shift;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDLIC_objectattributes_OBJECT()
	{
		ObjSource = (string)"name";
		Name = (string)"my_object_name";
		Property = (int)OBJPROP_PRICE1;
		FiboLevelID = (int)0;
		TLpriceLevel = (double)1.2;
		Shift = (int)0;
	}

	public: /* The main method */
	double _execute_()
	{
		string name = Name;
		
		if (ObjSource == "objloop") {name = LoadedObjectName();}
		if (ObjectFind(0,name)<0) {return EMPTY_VALUE;}
		
		double retval = 0;
		int modifier  = 0;
		
		double Fibo100  = 0;
		double Fibo0    = 0;
		double FiboDiff = 0;
		
		     if (Property == OBJPROP_TIME1)   {retval = (int)ObjectGetInteger(0,name,OBJPROP_TIME,0);}
		else if (Property == OBJPROP_TIME2)   {retval = (int)ObjectGetInteger(0,name,OBJPROP_TIME,1);}
		else if (Property == OBJPROP_TIME3)   {retval = (int)ObjectGetInteger(0,name,OBJPROP_TIME,2);}
		
		else if (Property == OBJPROP_PRICE1)  {retval = ObjectGetDouble(0,name,OBJPROP_PRICE,0);}
		else if (Property == OBJPROP_PRICE2)  {retval = ObjectGetDouble(0,name,OBJPROP_PRICE,1);}
		else if (Property == OBJPROP_PRICE3)  {retval = ObjectGetDouble(0,name,OBJPROP_PRICE,2);}
		
		else if (Property == OBJPROP_BARSHIFT1) {retval = iBarShift(Symbol(), Period(), (int)ObjectGetInteger(0,name,OBJPROP_TIME,0), true); if (retval==-1) {SkipThePass(true);}}
		else if (Property == OBJPROP_BARSHIFT2) {retval = iBarShift(Symbol(), Period(), (int)ObjectGetInteger(0,name,OBJPROP_TIME,1), true); if (retval==-1) {SkipThePass(true);}}
		else if (Property == OBJPROP_BARSHIFT3) {retval = iBarShift(Symbol(), Period(), (int)ObjectGetInteger(0,name,OBJPROP_TIME,2), true); if (retval==-1) {SkipThePass(true);}}
		
		else if (Property == OBJPROP_COLOR)      {retval = (int)ObjectGetInteger(0,name,OBJPROP_COLOR);}
		else if (Property == OBJPROP_STYLE)      {retval = (int)ObjectGetInteger(0,name,OBJPROP_STYLE);}
		else if (Property == OBJPROP_WIDTH)      {retval = (int)ObjectGetInteger(0,name,OBJPROP_WIDTH);}
		else if (Property == OBJPROP_BACK)       {retval = (int)ObjectGetInteger(0,name,OBJPROP_BACK);}
		else if (Property == OBJPROP_RAY_LEFT)   {retval = (int)ObjectGetInteger(0,name,OBJPROP_RAY_LEFT);}
		else if (Property == OBJPROP_RAY_RIGHT)  {retval = (int)ObjectGetInteger(0,name,OBJPROP_RAY_RIGHT);}
		else if (Property == OBJPROP_RAY)        {retval = (int)ObjectGetInteger(0,name,OBJPROP_RAY);}
		else if (Property == OBJPROP_ELLIPSE)    {retval = (int)ObjectGetInteger(0,name,OBJPROP_ELLIPSE);}
		else if (Property == OBJPROP_ARROWCODE)  {retval = (int)ObjectGetInteger(0,name,OBJPROP_ARROWCODE);}
		else if (Property == OBJPROP_FONTSIZE)   {retval = (int)ObjectGetInteger(0,name,OBJPROP_FONTSIZE);}
		else if (Property == OBJPROP_CORNER)     {retval = (int)ObjectGetInteger(0,name,OBJPROP_CORNER);}
		else if (Property == OBJPROP_XDISTANCE)  {retval = (int)ObjectGetInteger(0,name,OBJPROP_XDISTANCE);}
		else if (Property == OBJPROP_YDISTANCE)  {retval = (int)ObjectGetInteger(0,name,OBJPROP_YDISTANCE);}
		else if (Property == OBJPROP_LEVELCOLOR) {retval = (int)ObjectGetInteger(0,name,OBJPROP_LEVELCOLOR);}
		else if (Property == OBJPROP_LEVELSTYLE) {retval = (int)ObjectGetInteger(0,name,OBJPROP_LEVELSTYLE);}
		else if (Property == OBJPROP_LEVELWIDTH) {retval = (int)ObjectGetInteger(0,name,OBJPROP_LEVELWIDTH);}
		else if (Property == OBJPROP_ANCHOR)     {retval = (int)ObjectGetInteger(0,name,OBJPROP_ANCHOR);}
		else if (Property == OBJPROP_DIRECTION)  {retval = (int)ObjectGetInteger(0,name,OBJPROP_DIRECTION);}
		else if (Property == OBJPROP_DEGREE)     {retval = (int)ObjectGetInteger(0,name,OBJPROP_DEGREE);}
		else if (Property == OBJPROP_DRAWLINES)  {retval = (int)ObjectGetInteger(0,name,OBJPROP_DRAWLINES);}
		else if (Property == OBJPROP_STATE)      {retval = (int)ObjectGetInteger(0,name,OBJPROP_STATE);}
		else if (Property == OBJPROP_XSIZE)      {retval = (int)ObjectGetInteger(0,name,OBJPROP_XSIZE);}
		else if (Property == OBJPROP_YSIZE)      {retval = (int)ObjectGetInteger(0,name,OBJPROP_YSIZE);}
		else if (Property == OBJPROP_PERIOD)     {retval = (int)ObjectGetInteger(0,name,OBJPROP_PERIOD);}
		else if (Property == OBJPROP_LEVELS)     {retval = (int)ObjectGetInteger(0,name,OBJPROP_LEVELS);}
		
		else if (Property == OBJPROP_ANGLE)      {retval = ObjectGetDouble(0,name,OBJPROP_ANGLE);}
		else if (Property == OBJPROP_SCALE)      {retval = ObjectGetDouble(0,name,OBJPROP_SCALE);}
		else if (Property == OBJPROP_DEVIATION)  {retval = ObjectGetDouble(0,name,OBJPROP_DEVIATION);}
		
		else if (Property == OBJPROP_FIRSTLEVEL)        {retval = ObjectGetDouble(0,name,OBJPROP_LEVELVALUE,FiboLevelID);}
		else if (Property == OBJPROP_TL_PRICE_BY_SHIFT) {retval = ObjectGetValueByShift(name, Shift+FXD_MORE_SHIFT);}
		else if (Property == OBJPROP_TL_SHIFT_BY_PRICE) {retval = ObjectGetShiftByValue(name,TLpriceLevel);}
		
		else if (Property == OBJPROP_FIBOVALUE) {
			Fibo100  = ObjectGetDouble(0,name,OBJPROP_PRICE,0);
			Fibo0    = ObjectGetDouble(0,name,OBJPROP_PRICE,1);
			FiboDiff = Fibo100 - Fibo0;
			retval=0;
			if (FiboDiff != 0) {retval = (SymbolInfoDouble(Symbol(),SYMBOL_BID)-Fibo0)/FiboDiff;}
		}
		else if (Property == OBJPROP_FIBOPRICEVALUE) {
			Fibo100  = ObjectGetDouble(0,name,OBJPROP_PRICE,0);
			Fibo0    = ObjectGetDouble(0,name,OBJPROP_PRICE,1);
			FiboDiff = Fibo100 - Fibo0;
			retval=(ObjectGetDouble(0,name,OBJPROP_LEVELVALUE,FiboLevelID)*(FiboDiff))+Fibo0;
		}
		
		return retval;
	}
};

// "Numeric" model
class MDLIC_value_value
{
	public: /* Input Parameters */
	double Value;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDLIC_value_value()
	{
		Value = (double)1.0;
	}

	public: /* The main method */
	double _execute_()
	{
		return Value;
	}
};

// "Text" model
class MDLIC_text_text
{
	public: /* Input Parameters */
	string Text;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDLIC_text_text()
	{
		Text = (string)"sample text";
	}

	public: /* The main method */
	string _execute_()
	{
		return Text;
	}
};

// "Boolean" model
class MDLIC_boolean_boolean
{
	public: /* Input Parameters */
	bool Boolean;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDLIC_boolean_boolean()
	{
		Boolean = (bool)true;
	}

	public: /* The main method */
	bool _execute_()
	{
		return Boolean;
	}
};

// "Ask, Bid, Mid" model
class MDLIC_prices_prices
{
	public: /* Input Parameters */
	string Price;
	int TickID;
	string Symbol;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDLIC_prices_prices()
	{
		Price = (string)"ASK";
		TickID = (int)0;
		Symbol = (string)CurrentSymbol();
	}

	public: /* The main method */
	double _execute_()
	{
		int digits = (int)SymbolInfoInteger(Symbol, SYMBOL_DIGITS);
		
		double retval = 0;
		int tID       = TickID + FXD_MORE_SHIFT;
		
		     if (Price == "ASK")      {retval = TicksData(Symbol,SYMBOL_ASK,tID);}
		else if (Price == "BID")      {retval = TicksData(Symbol,SYMBOL_BID,tID);}
		else if (Price == "MID")      {retval = ((TicksData(Symbol,SYMBOL_ASK,tID)+TicksData(Symbol,SYMBOL_BID,tID))/2);}
		else if (Price == "BIDHIGH")  {retval = SymbolInfoDouble(Symbol,SYMBOL_BIDHIGH);}
		else if (Price == "BIDLOW")   {retval = SymbolInfoDouble(Symbol,SYMBOL_BIDLOW);}
		else if (Price == "ASKHIGH")  {retval = SymbolInfoDouble(Symbol,SYMBOL_ASKHIGH);}
		else if (Price == "ASKLOW")   {retval = SymbolInfoDouble(Symbol,SYMBOL_ASKLOW);}
		else if (Price == "LAST")     {retval = SymbolInfoDouble(Symbol,SYMBOL_LAST);}
		else if (Price == "LASTHIGH") {retval = SymbolInfoDouble(Symbol,SYMBOL_LASTHIGH);}
		else if (Price == "LASTLOW")  {retval = SymbolInfoDouble(Symbol,SYMBOL_LASTLOW);}
		
		return NormalizeDouble(retval, digits);
	}
};

// "Equity" model
class MDLIC_account_AccountEquity
{
	public: /* Input Parameters */
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDLIC_account_AccountEquity()
	{
	}

	public: /* The main method */
	double _execute_()
	{
		return NormalizeDouble(AccountInfoDouble(ACCOUNT_EQUITY), 2);
	}
};

// "Name: Currency (base / quote)" model
class MDLIC_market_Currency
{
	public: /* Input Parameters */
	int ModeCurrency;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDLIC_market_Currency()
	{
		ModeCurrency = (int)0;
	}

	public: /* The main method */
	string _execute_()
	{
		string retval = CurrentSymbol();
		
		if (ModeCurrency == 0) {
		   retval = StringSubstr(retval, 0, 3);
		}
		else {
		   retval = StringSubstr(retval, 3, 3);
		}
		
		return(retval);
	}
};

// "Money per tick" model
class MDLIC_market_tickvalue
{
	public: /* Input Parameters */
	string Symbol;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDLIC_market_tickvalue()
	{
		Symbol = (string)CurrentSymbol();
	}

	public: /* The main method */
	double _execute_()
	{
		return NormalizeDouble(SymbolInfoDouble(Symbol, SYMBOL_TRADE_TICK_VALUE), 8);
	}
};

// "Attributes set 2 (text)" model
class MDLIC_objectattributes_string
{
	public: /* Input Parameters */
	string ObjSource;
	string Name;
	ENUM_OBJECT_PROPERTY_STRING Property;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDLIC_objectattributes_string()
	{
		ObjSource = (string)"name";
		Name = (string)"my_object_name";
		Property = (ENUM_OBJECT_PROPERTY_STRING)OBJPROP_TEXT;
	}

	public: /* The main method */
	string _execute_()
	{
		string name = Name;
		
		if (ObjSource == "objloop") {name = LoadedObjectName();}
		
		if (ObjectFind(0,name) < 0)
		{
			return EMPTY_VALUE;
		}
		
		string retval = "";
		
		if (Property == OBJPROP_NAME)    {retval = ObjectGetString(0,name,OBJPROP_NAME,0);}
		if (Property == OBJPROP_TEXT)    {retval = ObjectGetString(0,name,OBJPROP_TEXT,0);}
		if (Property == OBJPROP_TOOLTIP) {retval = ObjectGetString(0,name,OBJPROP_TOOLTIP,0);}
		if (Property == OBJPROP_FONT)    {retval = ObjectGetString(0,name,OBJPROP_FONT,0);}
		if (Property == OBJPROP_SYMBOL)  {retval = ObjectGetString(0,name,OBJPROP_SYMBOL,0);}
		
		return retval;
	}
};

// "Profit" model
class MDLIC_inloop_OrderProfit
{
	public: /* Input Parameters */
	int ModeProfit;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDLIC_inloop_OrderProfit()
	{
		ModeProfit = (int)0;
	}

	public: /* The main method */
	double _execute_()
	{
		double retval = 0;
		
		if (OrderType() > 1)
		{
			return 0;
		}
		
		switch(ModeProfit)
		{
		   case 0: retval = NormalizeDouble(OrderProfit(), 2); break;
		   case 1: retval = NormalizeDouble(OrderProfit() + OrderSwap() + OrderCommission(), 2); break;
		   case 2: {
				int digits = (int)SymbolInfoInteger(OrderSymbol(), SYMBOL_DIGITS);
				retval = OrderClosePrice() - OrderOpenPrice();
				retval = NormalizeDouble(retval, digits);
				if (IsOrderTypeSell()) {retval = -1 * retval;}
				break;
			}
		   case 3: {
				int digits = (int)SymbolInfoInteger(OrderSymbol(), SYMBOL_DIGITS);
				retval = toPips(OrderClosePrice() - OrderOpenPrice(), OrderSymbol());
				retval = NormalizeDouble(retval, digits);
				if (IsOrderTypeSell()) {retval = -1 * retval;}
				break;
			}
		}
		
		return retval;
	}
};

// "Stop-Loss" model
class MDLIC_inloop_OrderStopLoss
{
	public: /* Input Parameters */
	string Mode;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDLIC_inloop_OrderStopLoss()
	{
		Mode = (string)"level";
	}

	public: /* The main method */
	double _execute_()
	{
		double retval = 0;
		int digits    = (int)SymbolInfoInteger(OrderSymbol(), SYMBOL_DIGITS);
		
		if (Mode == "level")
		{
		   retval = attrStopLoss();
		}
		else if (Mode == "fraction")
		{
		   if (attrStopLoss() > 0)
			{
		      retval = MathAbs(OrderOpenPrice()-attrStopLoss());
		   }
		}
		else if (Mode == "pips")
		{
			if (attrStopLoss() > 0)
			{
				double point = SymbolInfoDouble(OrderSymbol(), SYMBOL_POINT);
		
			   retval = MathAbs(OrderOpenPrice()-attrStopLoss())/(PipValue(OrderSymbol())*point);
			}
		}
		
		return NormalizeDouble(retval, digits);
	}
};

// "Open Price" model
class MDLIC_inloop_OrderOpenPrice
{
	public: /* Input Parameters */
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDLIC_inloop_OrderOpenPrice()
	{
	}

	public: /* The main method */
	double _execute_()
	{
		return OrderOpenPrice();
	}
};

// "Digits count (after the point)" model
class MDLIC_market_digits
{
	public: /* Input Parameters */
	int ModeDigits;
	string Symbol;
	virtual void _callback_(int r) {return;}

	public: /* Constructor */
	MDLIC_market_digits()
	{
		ModeDigits = (int)0;
		Symbol = (string)CurrentSymbol();
	}

	public: /* The main method */
	int _execute_()
	{
		switch (ModeDigits)
		{
		   case 0: return (int)SymbolInfoInteger(Symbol, SYMBOL_DIGITS);
		   case 1: return CustomDigits(Symbol);
		}
		
		return 0;
	}
};


//------------------------------------------------------------------------------------------------------------------------

// Block 3 (Mouse clicked on objectbtnOpenCalc)
class Block0: public MDL_eChart_MouseClickObject<string,string>
{

	public: /* Constructor */
	Block0() {
		__block_number = 0;
		__block_user_number = "3";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {24};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		NameFilterMode = "name";
		ObjName = "btnOpenCalc";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[24].run(0);
		}
	}
};

// Block 4 (Mouse clicked on objectbtnOpenTrade)
class Block1: public MDL_eChart_MouseClickObject<string,string>
{

	public: /* Constructor */
	Block1() {
		__block_number = 1;
		__block_user_number = "4";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {83};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		NameFilterMode = "name";
		ObjName = "btnOpenTrade";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[83].run(1);
		}
	}
};

// Block 5 (Draw SL Line)
class Block2: public MDL_ChartDrawLine<bool,bool,string,ENUM_OBJECT,MDLIC_value_time,datetime,MDLIC_prices_LowestFromToCandles,double,MDLIC_value_time,datetime,MDLIC_candles_candles,double,double,bool,bool,bool,color,ENUM_LINE_STYLE,int,bool,bool,bool,bool,int,string>
{

	public: /* Constructor */
	Block2() {
		__block_number = 2;
		__block_user_number = "5";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {5,8};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		ObjTime1.ModeTime = 3;
		ObjTime1.TimeCandleID = 0;
		ObjPrice1.StartBar = 2;
		ObjPrice1.EndBar = 20;
		ObjTime2.ModeTime = 3;
		ObjTime2.TimeCandleID = 10;
		ObjPrice2.CandleID = 10;
		ObjPrice2.TimeStamp = "";
		// Block input parameters
		ObjectPerBar = false;
		ObjName = "lineSL";
		ObjWidth = 3;
		ObjSelected = true;
		ObjHidden = true;
	}

	public: /* Custom methods */
	virtual datetime _ObjTime1_() {return ObjTime1._execute_();}
	virtual double _ObjPrice1_() {
		ObjPrice1.Symbol = CurrentSymbol();
		ObjPrice1.Period = CurrentTimeframe();

		return ObjPrice1._execute_();
	}
	virtual datetime _ObjTime2_() {return ObjTime2._execute_();}
	virtual double _ObjPrice2_() {
		ObjPrice2.Symbol = CurrentSymbol();
		ObjPrice2.Period = CurrentTimeframe();

		return ObjPrice2._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[5].run(2);
			_blocks_[8].run(2);
		}
	}

	virtual void _beforeExecute_()
	{

		ObjectType = (ENUM_OBJECT)OBJ_HLINE;
		ObjColor = (color)c::SL_Line_Color;
		ObjStyle = (ENUM_LINE_STYLE)STYLE_SOLID;
	}
};

// Block 8 (SL Line&nbsp; dragged)
class Block3: public MDL_eChart_ObjectDrag<string,string>
{

	public: /* Constructor */
	Block3() {
		__block_number = 3;
		__block_user_number = "8";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {5};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		NameFilterMode = "name";
		ObjName = "lineSL";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[5].run(3);
		}
	}
};

// Block 13 (Draw TP Line)
class Block4: public MDL_ChartDrawLine<bool,bool,string,ENUM_OBJECT,MDLIC_value_time,datetime,MDLIC_prices_HighestFromToCandles,double,MDLIC_value_time,datetime,MDLIC_candles_candles,double,double,bool,bool,bool,color,ENUM_LINE_STYLE,int,bool,bool,bool,bool,int,string>
{

	public: /* Constructor */
	Block4() {
		__block_number = 4;
		__block_user_number = "13";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {7,9};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		ObjTime1.ModeTime = 3;
		ObjTime1.TimeCandleID = 0;
		ObjPrice1.StartBar = 2;
		ObjPrice1.EndBar = 20;
		ObjTime2.ModeTime = 3;
		ObjTime2.TimeCandleID = 10;
		ObjPrice2.CandleID = 10;
		ObjPrice2.TimeStamp = "";
		// Block input parameters
		ObjectPerBar = false;
		ObjName = "lineTP";
		ObjRay = false;
		ObjWidth = 3;
		ObjSelected = true;
		ObjHidden = true;
	}

	public: /* Custom methods */
	virtual datetime _ObjTime1_() {return ObjTime1._execute_();}
	virtual double _ObjPrice1_() {
		ObjPrice1.Symbol = CurrentSymbol();
		ObjPrice1.Period = CurrentTimeframe();

		return ObjPrice1._execute_();
	}
	virtual datetime _ObjTime2_() {return ObjTime2._execute_();}
	virtual double _ObjPrice2_() {
		ObjPrice2.Symbol = CurrentSymbol();
		ObjPrice2.Period = CurrentTimeframe();

		return ObjPrice2._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[7].run(4);
			_blocks_[9].run(4);
		}
	}

	virtual void _beforeExecute_()
	{

		ObjectType = (ENUM_OBJECT)OBJ_HLINE;
		ObjColor = (color)c::TP_Line_Color;
		ObjStyle = (ENUM_LINE_STYLE)STYLE_SOLID;
	}
};

// Block 14 (Modify Variablesprice_sl)
class Block5: public MDL_ModifyVariables<int,MDLIC_objectattributes_OBJECT,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block5() {
		__block_number = 5;
		__block_user_number = "14";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {15};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Name = "lineSL";
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.Property = OBJPROP_PRICE1;

		return Value1._execute_();
	}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[15].run(5);
		}
	}

	virtual void _beforeExecute_()
	{

		v::sl_price = _Value1_();
	}
};

// Block 16 (TP Line dragged)
class Block6: public MDL_eChart_ObjectDrag<string,string>
{

	public: /* Constructor */
	Block6() {
		__block_number = 6;
		__block_user_number = "16";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {7};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		NameFilterMode = "name";
		ObjName = "lineTP";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[7].run(6);
		}
	}
};

// Block 22 (Modify Variablesprice_tp)
class Block7: public MDL_ModifyVariables<int,MDLIC_objectattributes_OBJECT,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block7() {
		__block_number = 7;
		__block_user_number = "22";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {15};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Name = "lineTP";
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.Property = OBJPROP_PRICE1;

		return Value1._execute_();
	}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[15].run(7);
		}
	}

	virtual void _beforeExecute_()
	{

		v::tp_price = _Value1_();
	}
};

// Block 23 (Draw&nbsp; SL Text)
class Block8: public MDL_ChartDrawText<bool,bool,string,ENUM_OBJECT,MDLIC_value_time,datetime,MDLIC_value_value,double,int,int,MDLIC_text_text,string,string,int,double,ENUM_BASE_CORNER,int,color,bool,bool,bool,bool,int,string>
{

	public: /* Constructor */
	Block8() {
		__block_number = 8;
		__block_user_number = "23";
		_beforeExecuteEnabled = true;

		// IC input parameters
		ObjTime1.ModeTime = 3;
		// Block input parameters
		ObjectPerBar = false;
		ObjName = "lblLineSL";
		ObjSelectable = false;
		ObjHidden = true;
	}

	public: /* Custom methods */
	virtual datetime _ObjTime1_() {return ObjTime1._execute_();}
	virtual double _ObjPrice1_() {
		ObjPrice1.Value = v::sl_price;

		return ObjPrice1._execute_();
	}
	virtual string _ObjText_() {
		ObjText.Text = v::sl_label_text;

		return ObjText._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		ObjectType = (ENUM_OBJECT)OBJ_TEXT;
		ObjCorner = (ENUM_BASE_CORNER)CORNER_LEFT_UPPER;
		ObjAnchor = (int)ANCHOR_RIGHT_UPPER;
		ObjColor = (color)c::SL_Line_Color;
	}
};

// Block 24 (Draw TP Text)
class Block9: public MDL_ChartDrawText<bool,bool,string,ENUM_OBJECT,MDLIC_value_time,datetime,MDLIC_value_value,double,int,int,MDLIC_text_text,string,string,int,double,ENUM_BASE_CORNER,int,color,bool,bool,bool,bool,int,string>
{

	public: /* Constructor */
	Block9() {
		__block_number = 9;
		__block_user_number = "24";
		_beforeExecuteEnabled = true;

		// IC input parameters
		ObjTime1.ModeTime = 3;
		// Block input parameters
		ObjectPerBar = false;
		ObjName = "lblLineTP";
		ObjSelectable = false;
		ObjHidden = true;
	}

	public: /* Custom methods */
	virtual datetime _ObjTime1_() {return ObjTime1._execute_();}
	virtual double _ObjPrice1_() {
		ObjPrice1.Value = v::tp_price;

		return ObjPrice1._execute_();
	}
	virtual string _ObjText_() {
		ObjText.Text = v::tp_label_text;

		return ObjText._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		ObjectType = (ENUM_OBJECT)OBJ_TEXT;
		ObjCorner = (ENUM_BASE_CORNER)CORNER_LEFT_UPPER;
		ObjAnchor = (int)ANCHOR_RIGHT_UPPER;
		ObjColor = (color)c::TP_Line_Color;
	}
};

// Block 26 (Mouse clicked on&nbsp;btnPendingOrder)
class Block10: public MDL_eChart_MouseClickObject<string,string>
{

	public: /* Constructor */
	Block10() {
		__block_number = 10;
		__block_user_number = "26";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {11,255};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		NameFilterMode = "name";
		ObjName = "btnPendingOrder";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[11].run(10);
			_blocks_[255].run(10);
		}
	}
};

// Block 28 (Conditionpending_order == true)
class Block11: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_boolean_boolean,bool,int>
{

	public: /* Constructor */
	Block11() {
		__block_number = 11;
		__block_user_number = "28";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {12,14};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual bool _Lo_() {return Lo._execute_();}
	virtual bool _Ro_() {
		Ro.Boolean = v::pending_order;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			v::pending_order = (bool)(true);
			_blocks_[12].run(11);
		}
		else if (value == 1) {
			v::pending_order = (bool)(false);
			_blocks_[14].run(11);
		}
	}
};

// Block 30 (Draw Pending Order Line)
class Block12: public MDL_ChartDrawLine<bool,bool,string,ENUM_OBJECT,MDLIC_value_time,datetime,MDLIC_candles_candles,double,MDLIC_value_time,datetime,MDLIC_candles_candles,double,double,bool,bool,bool,color,ENUM_LINE_STYLE,int,bool,bool,bool,bool,int,string>
{

	public: /* Constructor */
	Block12() {
		__block_number = 12;
		__block_user_number = "30";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {271,37};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		ObjTime1.ModeTime = 3;
		ObjTime1.TimeCandleID = 0;
		ObjPrice1.iOHLC = "iMedian";
		ObjPrice1.CandleID = 1;
		ObjTime2.ModeTime = 3;
		ObjTime2.TimeCandleID = 10;
		ObjPrice2.CandleID = 10;
		ObjPrice2.TimeStamp = "";
		// Block input parameters
		ObjectPerBar = false;
		ObjName = "linePendingOrder";
		ObjRayRight = true;
		ObjWidth = 3;
		ObjSelected = true;
		ObjHidden = true;
	}

	public: /* Custom methods */
	virtual datetime _ObjTime1_() {return ObjTime1._execute_();}
	virtual double _ObjPrice1_() {
		ObjPrice1.Symbol = CurrentSymbol();
		ObjPrice1.Period = CurrentTimeframe();

		return ObjPrice1._execute_();
	}
	virtual datetime _ObjTime2_() {return ObjTime2._execute_();}
	virtual double _ObjPrice2_() {
		ObjPrice2.Symbol = CurrentSymbol();
		ObjPrice2.Period = CurrentTimeframe();

		return ObjPrice2._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[37].run(12);
			_blocks_[271].run(12);
		}
	}

	virtual void _beforeExecute_()
	{

		ObjectType = (ENUM_OBJECT)OBJ_HLINE;
		ObjColor = (color)c::Pending_Line_Color;
		ObjStyle = (ENUM_LINE_STYLE)STYLE_SOLID;
	}
};

// Block 31 (Draw Pending Order Text)
class Block13: public MDL_ChartDrawText<bool,bool,string,ENUM_OBJECT,MDLIC_value_time,datetime,MDLIC_value_value,double,int,int,MDLIC_text_text,string,string,int,double,ENUM_BASE_CORNER,int,color,bool,bool,bool,bool,int,string>
{

	public: /* Constructor */
	Block13() {
		__block_number = 13;
		__block_user_number = "31";
		_beforeExecuteEnabled = true;

		// IC input parameters
		ObjTime1.ModeTime = 3;
		// Block input parameters
		ObjectPerBar = false;
		ObjName = "lblPendingOrder";
		ObjSelectable = false;
		ObjHidden = true;
	}

	public: /* Custom methods */
	virtual datetime _ObjTime1_() {return ObjTime1._execute_();}
	virtual double _ObjPrice1_() {
		ObjPrice1.Value = v::pending_order_price;

		return ObjPrice1._execute_();
	}
	virtual string _ObjText_() {
		ObjText.Text = v::pending_label_text;

		return ObjText._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		ObjectType = (ENUM_OBJECT)OBJ_TEXT;
		ObjCorner = (ENUM_BASE_CORNER)CORNER_LEFT_UPPER;
		ObjAnchor = (int)ANCHOR_RIGHT_UPPER;
		ObjColor = (color)c::Pending_Line_Color;
	}
};

// Block 32 (Delete pending order objects)
class Block14: public MDL_ChartDeleteObjects<string,string,color,string,int,int>
{

	public: /* Constructor */
	Block14() {
		__block_number = 14;
		__block_user_number = "32";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {27};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		NameContains = "lblPendingOrder";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[27].run(14);
		}
	}

	virtual void _beforeExecute_()
	{

		ObjColor = (color)EMPTY_VALUE;
	}
};

// Block 34 (Conditionpending_order == true)
class Block15: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_boolean_boolean,bool,int>
{

	public: /* Constructor */
	Block15() {
		__block_number = 15;
		__block_user_number = "34";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {21,33};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual bool _Lo_() {
		Lo.Boolean = v::pending_order;

		return Lo._execute_();
	}
	virtual bool _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[21].run(15);
		}
		else if (value == 1) {
			_blocks_[33].run(15);
		}
	}
};

// Block 36 (Formulasl distance pip)
class Block16: public MDL_Formula_1<MDLIC_prices_prices,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block16() {
		__block_number = 16;
		__block_user_number = "36";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {20};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "-";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Symbol = CurrentSymbol();

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::sl_price;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[20].run(16);
		}
	}
};

// Block 37 (Modify Variablessl text&nbsp;)
class Block17: public MDL_ModifyVariables<int,MDLIC_account_AccountEquity,double,int,MDLIC_text_text,string,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block17() {
		__block_number = 17;
		__block_user_number = "37";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {40};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value2.Text = "";
	}

	public: /* Custom methods */
	virtual double _Value1_() {		double value = (double)Value1._execute_();
		value = value/ 100  * v::risk_percent; // Adjust the value
		return value;
	}
	virtual string _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {
		Value3.Value = (NormalizeDouble((v::money_for_risk / (v::pip_value * v::sl_distance_pip  * v::pip_multiper )) , 2) ) < c::Maximum_Lot ? (NormalizeDouble((v::money_for_risk / (v::pip_value  * v::sl_distance_pip  * v::pip_multiper )) , 2) ) :  c::Maximum_Lot;

		return Value3._execute_();
	}
	virtual double _Value4_() {
		Value4.Value = v::calculated_volume < 0.01 ? 0.01 : v::calculated_volume;

		return Value4._execute_();
	}
	virtual double _Value5_() {
		Value5.Value = NormalizeDouble( v::pip_value * v::sl_distance_pip *  v::calculated_volume * v::pip_multiper , 2);

		return Value5._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[40].run(17);
		}
	}

	virtual void _beforeExecute_()
	{

		v::money_for_risk = _Value1_();
		v::tp_label_text = _Value2_();
		v::calculated_volume = _Value3_();
		v::calculated_volume = _Value4_();
		v::money_at_risk = _Value5_();
	}
};

// Block 45 (Conditionpair is jpy or not)
class Block18: public MDL_Condition<MDLIC_market_Currency,string,string,MDLIC_text_text,string,int>
{

	public: /* Constructor */
	Block18() {
		__block_number = 18;
		__block_user_number = "45";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {19};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Lo.ModeCurrency = 1;
		Ro.Text = "JPY";
		// Block input parameters
		compare = "!=";
	}

	public: /* Custom methods */
	virtual string _Lo_() {return Lo._execute_();}
	virtual string _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[19].run(18);
		}
	}
};

// Block 49 (Modify Variablesis jpy)
class Block19: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block19() {
		__block_number = 19;
		__block_user_number = "49";
		_beforeExecuteEnabled = true;

		// IC input parameters
		Value1.Value = 100.0;
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		v::pip_multiper = _Value1_();
	}
};

// Block 54 (Formulatp distance pip)
class Block20: public MDL_Formula_2<MDLIC_prices_prices,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block20() {
		__block_number = 20;
		__block_user_number = "54";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {17};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Lo.Price = "BID";
		// Block input parameters
		compare = "-";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Symbol = CurrentSymbol();

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::tp_price;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[17].run(20);
		}
	}
};

// Block 55 (Conditionsl line is blow price)
class Block21: public MDL_Condition<MDLIC_prices_prices,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block21() {
		__block_number = 21;
		__block_user_number = "55";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {16,22};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Lo.Price = "BID";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Symbol = CurrentSymbol();

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::sl_price;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[22].run(21);
		}
		else if (value == 1) {
			_blocks_[16].run(21);
		}
	}
};

// Block 56 (Formulasl distance pip)
class Block22: public MDL_Formula_3<MDLIC_value_value,double,string,MDLIC_prices_prices,double>
{

	public: /* Constructor */
	Block22() {
		__block_number = 22;
		__block_user_number = "56";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {23};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Price = "BID";
		// Block input parameters
		compare = "-";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::sl_price;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Symbol = CurrentSymbol();

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[23].run(22);
		}
	}
};

// Block 74 (Formulatp distance pip)
class Block23: public MDL_Formula_4<MDLIC_value_value,double,string,MDLIC_prices_prices,double>
{

	public: /* Constructor */
	Block23() {
		__block_number = 23;
		__block_user_number = "74";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {17};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "-";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::tp_price;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Symbol = CurrentSymbol();

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[17].run(23);
		}
	}
};

// Block 75 (Conditioncal_is_open&nbsp;== true)
class Block24: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_boolean_boolean,bool,int>
{

	public: /* Constructor */
	Block24() {
		__block_number = 24;
		__block_user_number = "75";


		// Fill the list of outbound blocks
		int ___outbound_blocks[4] = {2,25,30,4};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual bool _Lo_() {return Lo._execute_();}
	virtual bool _Ro_() {
		Ro.Boolean = v::cal_is_open;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			v::cal_is_open = (bool)(true);
			_blocks_[2].run(24);
			_blocks_[4].run(24);
			_blocks_[30].run(24);
		}
		else if (value == 1) {
			v::cal_is_open = (bool)(false);
			_blocks_[25].run(24);
		}
	}
};

// Block 76 (Delete tp line)
class Block25: public MDL_ChartDeleteObjects<string,string,color,string,int,int>
{

	public: /* Constructor */
	Block25() {
		__block_number = 25;
		__block_user_number = "76";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {26};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		NameContains = "ineTP";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[26].run(25);
		}
	}

	virtual void _beforeExecute_()
	{

		ObjColor = (color)EMPTY_VALUE;
	}
};

// Block 77 (Delete sl line)
class Block26: public MDL_ChartDeleteObjects<string,string,color,string,int,int>
{

	public: /* Constructor */
	Block26() {
		__block_number = 26;
		__block_user_number = "77";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {28};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		NameContains = "ineSL";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[28].run(26);
		}
	}

	virtual void _beforeExecute_()
	{

		ObjColor = (color)EMPTY_VALUE;
	}
};

// Block 79 (Delete pending order objects)
class Block27: public MDL_ChartDeleteObjects<string,string,color,string,int,int>
{

	public: /* Constructor */
	Block27() {
		__block_number = 27;
		__block_user_number = "79";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {15};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		NameContains = "linePendingOrder";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[15].run(27);
		}
	}

	virtual void _beforeExecute_()
	{

		ObjColor = (color)EMPTY_VALUE;
	}
};

// Block 80 (Delete pending order objects)
class Block28: public MDL_ChartDeleteObjects<string,string,color,string,int,int>
{

	public: /* Constructor */
	Block28() {
		__block_number = 28;
		__block_user_number = "80";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {29};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		NameContains = "lblPendingOrder";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[29].run(28);
		}
	}

	virtual void _beforeExecute_()
	{

		ObjColor = (color)EMPTY_VALUE;
	}
};

// Block 127 (Delete pending order objects)
class Block29: public MDL_ChartDeleteObjects<string,string,color,string,int,int>
{

	public: /* Constructor */
	Block29() {
		__block_number = 29;
		__block_user_number = "127";
		_beforeExecuteEnabled = true;
		// Block input parameters
		NameContains = "linePendingOrder";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		ObjColor = (color)EMPTY_VALUE;
	}
};

// Block 129 (Conditionpending_order == true)
class Block30: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_boolean_boolean,bool,int>
{

	public: /* Constructor */
	Block30() {
		__block_number = 30;
		__block_user_number = "129";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {12};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual bool _Lo_() {return Lo._execute_();}
	virtual bool _Ro_() {
		Ro.Boolean = v::pending_order;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[12].run(30);
		}
	}
};

// Block 130 (Formulasl distance pip)
class Block31: public MDL_Formula_5<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block31() {
		__block_number = 31;
		__block_user_number = "130";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {32};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "-";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::pending_order_price;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::sl_price;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[32].run(31);
		}
	}
};

// Block 148 (Formulatp distance pip)
class Block32: public MDL_Formula_6<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block32() {
		__block_number = 32;
		__block_user_number = "148";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {17};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "-";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::pending_order_price;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::tp_price;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[17].run(32);
		}
	}
};

// Block 149 (Conditionsl line is blow pending line)
class Block33: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block33() {
		__block_number = 33;
		__block_user_number = "149";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {31,34};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::pending_order_price;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::sl_price;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[34].run(33);
		}
		else if (value == 1) {
			_blocks_[31].run(33);
		}
	}
};

// Block 150 (Formulasl distance pip)
class Block34: public MDL_Formula_7<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block34() {
		__block_number = 34;
		__block_user_number = "150";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {35};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "-";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::sl_price;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::pending_order_price;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[35].run(34);
		}
	}
};

// Block 168 (Formulatp distance pip)
class Block35: public MDL_Formula_8<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block35() {
		__block_number = 35;
		__block_user_number = "168";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {17};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "-";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::tp_price;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::pending_order_price;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[17].run(35);
		}
	}
};

// Block 169 (Pending Line dragged)
class Block36: public MDL_eChart_ObjectDrag<string,string>
{

	public: /* Constructor */
	Block36() {
		__block_number = 36;
		__block_user_number = "169";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {37};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		NameFilterMode = "name";
		ObjName = "linePendingOrder";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[37].run(36);
		}
	}
};

// Block 170 (Modify Variablespending order price)
class Block37: public MDL_ModifyVariables<int,MDLIC_objectattributes_OBJECT,double,int,MDLIC_text_text,string,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block37() {
		__block_number = 37;
		__block_user_number = "170";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {15,257};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Name = "linePendingOrder";
		Value2.Text = "";
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.Property = OBJPROP_PRICE1;

		return Value1._execute_();
	}
	virtual string _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[15].run(37);
			_blocks_[257].run(37);
		}
	}

	virtual void _beforeExecute_()
	{

		v::pending_order_price = _Value1_();
	}
};

// Block 172 (Modify Variablesset pip_value)
class Block38: public MDL_ModifyVariables<int,MDLIC_market_tickvalue,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block38() {
		__block_number = 38;
		__block_user_number = "172";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {53};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.Symbol = CurrentSymbol();

		return Value1._execute_();
	}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[53].run(38);
		}
	}

	virtual void _beforeExecute_()
	{

		v::pip_value = _Value1_();
	}
};

// Block 173 (Once per tick)
class Block39: public MDL_OncePerTick<string>
{

	public: /* Constructor */
	Block39() {
		__block_number = 39;
		__block_user_number = "173";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {110};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[110].run(39);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
	}
};

// Block 174 (Modify Variables)
class Block40: public MDL_ModifyVariables<int,MDLIC_text_text,string,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_text_text,string>
{

	public: /* Constructor */
	Block40() {
		__block_number = 40;
		__block_user_number = "174";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {8,9};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual string _Value1_() {
		Value1.Text = "Pips : " + (MathAbs(NormalizeDouble ( (v::sl_distance_pip  * v::pip_multiper /10 ) , 1 ))) + "  Loss: "  + v::money_at_risk + "$  Vol:" + MathRound(NormalizeDouble(v::calculated_volume * v::risk_percent_factor, 2) * 100 ) / 100;

		return Value1._execute_();
	}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual string _Value5_() {
		Value5.Text = "Pips : " + (MathAbs(NormalizeDouble ( (v::tp_distance_pip  * v::pip_multiper /10) , 1 ))) +  "  Profit:"+ NormalizeDouble(  v::pip_value * MathAbs(v::tp_distance_pip) *  v::calculated_volume * v::pip_multiper , 2) + "$  RR : " + ( MathAbs( NormalizeDouble  ( (v::tp_distance_pip /  v::sl_distance_pip  ) , 1 )));

		return Value5._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[8].run(40);
			_blocks_[9].run(40);
		}
	}

	virtual void _beforeExecute_()
	{

		v::sl_label_text = _Value1_();
		v::tp_label_text = _Value5_();
	}
};

// Block 176 (Conditionpending_order == true)
class Block41: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_boolean_boolean,bool,int>
{

	public: /* Constructor */
	Block41() {
		__block_number = 41;
		__block_user_number = "176";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {44,50};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual bool _Lo_() {return Lo._execute_();}
	virtual bool _Ro_() {
		Ro.Boolean = v::pending_order;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[50].run(41);
		}
		else if (value == 1) {
			_blocks_[44].run(41);
		}
	}
};

// Block 179 (Buy pending order)
class Block42: public MDL_BuyPending<string,string,string,MDLIC_value_value,double,double,string,double,double,double,double,double,MDLIC_value_value,double,double,double,double,double,double,double,double,int,int,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,int,int,int,MDLIC_value_time,datetime,int,ulong,string,color>
{

	public: /* Constructor */
	Block42() {
		__block_number = 42;
		__block_user_number = "179";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {24,81};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		dVolumeSize.Value = 0.1;
		dpStopLoss.Value = 100.0;
		ddStopLoss.Value = 0.01;
		ddTakeProfit.Value = 0.01;
		dpTakeProfit.Value = 100.0;
		dExp.ModeTimeShift = 2;
		dExp.TimeShiftDays = 1.0;
		dExp.TimeSkipWeekdays = true;
		// Block input parameters
		Price = "dynamic";
		PriceOffset = 0.0;
		VolumeMode = "safeMargin";
		StopLossMode = "dynamicLevel";
		TakeProfitMode = "dynamicLevel";
	}

	public: /* Custom methods */
	virtual double _dPrice_() {
		dPrice.Value = v::pending_order_price;

		return dPrice._execute_();
	}
	virtual double _dVolumeSize_() {return dVolumeSize._execute_();}
	virtual double _dlStopLoss_() {
		dlStopLoss.Value = v::sl_price;

		return dlStopLoss._execute_();
	}
	virtual double _dpStopLoss_() {return dpStopLoss._execute_();}
	virtual double _ddStopLoss_() {return ddStopLoss._execute_();}
	virtual double _dlTakeProfit_() {
		dlTakeProfit.Value = v::tp_price;

		return dlTakeProfit._execute_();
	}
	virtual double _ddTakeProfit_() {return ddTakeProfit._execute_();}
	virtual double _dpTakeProfit_() {return dpTakeProfit._execute_();}
	virtual datetime _dExp_() {return dExp._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[81].run(42);
		}
		else if (value == 1) {
			_blocks_[24].run(42);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		VolumeRisk = (double)v::correct_risk_percent;
		VolumeUpperLimit = (double)c::Maximum_Lot;
		MyComment = (string)v::position_comment;
		ArrowColorBuy = (color)clrBlue;
	}
};

// Block 182 (Conditionsl line is below Bid)
class Block43: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_prices_prices,double,int>
{

	public: /* Constructor */
	Block43() {
		__block_number = 43;
		__block_user_number = "182";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {42};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Price = "BID";
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::sl_price;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Symbol = CurrentSymbol();

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[42].run(43);
		}
	}
};

// Block 183 (Conditiontp line is above Ask)
class Block44: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_prices_prices,double,int>
{

	public: /* Constructor */
	Block44() {
		__block_number = 44;
		__block_user_number = "183";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {43,45};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::tp_price;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Symbol = CurrentSymbol();

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[45].run(44);
		}
		else if (value == 1) {
			_blocks_[43].run(44);
		}
	}
};

// Block 184 (Conditionsl line is below Bid)
class Block45: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_prices_prices,double,int>
{

	public: /* Constructor */
	Block45() {
		__block_number = 45;
		__block_user_number = "184";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {46};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::sl_price;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Symbol = CurrentSymbol();

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[46].run(45);
		}
	}
};

// Block 185 (Sell pending order)
class Block46: public MDL_SellPending<string,string,string,MDLIC_value_value,double,double,string,double,double,double,double,double,MDLIC_value_value,double,double,double,double,double,double,double,double,int,int,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,int,int,int,MDLIC_value_time,datetime,int,ulong,string,color>
{

	public: /* Constructor */
	Block46() {
		__block_number = 46;
		__block_user_number = "185";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {24,81};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		dVolumeSize.Value = 0.1;
		dpStopLoss.Value = 100.0;
		ddStopLoss.Value = 0.01;
		ddTakeProfit.Value = 0.01;
		dpTakeProfit.Value = 100.0;
		dExp.ModeTimeShift = 2;
		dExp.TimeShiftDays = 1.0;
		dExp.TimeSkipWeekdays = true;
		// Block input parameters
		Price = "dynamic";
		PriceOffset = 0.0;
		VolumeMode = "safeMargin";
		StopLossMode = "dynamicLevel";
		TakeProfitMode = "dynamicLevel";
	}

	public: /* Custom methods */
	virtual double _dPrice_() {
		dPrice.Value = v::pending_order_price;

		return dPrice._execute_();
	}
	virtual double _dVolumeSize_() {return dVolumeSize._execute_();}
	virtual double _dlStopLoss_() {
		dlStopLoss.Value = v::sl_price;

		return dlStopLoss._execute_();
	}
	virtual double _dpStopLoss_() {return dpStopLoss._execute_();}
	virtual double _ddStopLoss_() {return ddStopLoss._execute_();}
	virtual double _dlTakeProfit_() {
		dlTakeProfit.Value = v::tp_price;

		return dlTakeProfit._execute_();
	}
	virtual double _ddTakeProfit_() {return ddTakeProfit._execute_();}
	virtual double _dpTakeProfit_() {return dpTakeProfit._execute_();}
	virtual datetime _dExp_() {return dExp._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[81].run(46);
		}
		else if (value == 1) {
			_blocks_[24].run(46);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		VolumeRisk = (double)v::correct_risk_percent;
		VolumeUpperLimit = (double)c::Maximum_Lot;
		MyComment = (string)v::position_comment;
		ArrowColorSell = (color)clrRed;
	}
};

// Block 186 (Buy now)
class Block47: public MDL_BuyNow<string,string,string,double,double,double,double,double,MDLIC_value_value,double,double,double,int,double,double,double,double,double,int,int,double,bool,double,double,bool,double,string,bool,double,string,string,bool,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,int,int,int,MDLIC_value_time,datetime,ulong,string,color>
{

	public: /* Constructor */
	Block47() {
		__block_number = 47;
		__block_user_number = "186";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {24,81};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		dVolumeSize.Value = 0.1;
		dpStopLoss.Value = 100.0;
		ddStopLoss.Value = 0.01;
		dpTakeProfit.Value = 100.0;
		ddTakeProfit.Value = 0.01;
		dExp.ModeTimeShift = 2;
		dExp.TimeShiftDays = 1.0;
		dExp.TimeSkipWeekdays = true;
		// Block input parameters
		VolumeMode = "equityRisk";
		StopLossMode = "dynamicLevel";
		TakeProfitMode = "dynamicLevel";
	}

	public: /* Custom methods */
	virtual double _dVolumeSize_() {return dVolumeSize._execute_();}
	virtual double _dlStopLoss_() {
		dlStopLoss.Value = v::sl_price;

		return dlStopLoss._execute_();
	}
	virtual double _dpStopLoss_() {return dpStopLoss._execute_();}
	virtual double _ddStopLoss_() {return ddStopLoss._execute_();}
	virtual double _dlTakeProfit_() {
		dlTakeProfit.Value = v::tp_price;

		return dlTakeProfit._execute_();
	}
	virtual double _dpTakeProfit_() {return dpTakeProfit._execute_();}
	virtual double _ddTakeProfit_() {return ddTakeProfit._execute_();}
	virtual datetime _dExp_() {return dExp._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[81].run(47);
		}
		else if (value == 1) {
			_blocks_[24].run(47);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		VolumeRisk = (double)v::correct_risk_percent;
		VolumeUpperLimit = (double)c::Maximum_Lot;
		MyComment = (string)v::position_comment;
		ArrowColorBuy = (color)clrBlue;
	}
};

// Block 187 (Sell now)
class Block48: public MDL_SellNow<string,string,string,double,double,double,double,double,MDLIC_value_value,double,double,double,int,double,double,double,double,double,int,int,double,bool,double,double,bool,double,string,bool,double,string,string,bool,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,int,int,int,MDLIC_value_time,datetime,ulong,string,color>
{

	public: /* Constructor */
	Block48() {
		__block_number = 48;
		__block_user_number = "187";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {24,81};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		dVolumeSize.Value = 0.1;
		dpStopLoss.Value = 100.0;
		ddStopLoss.Value = 0.01;
		dpTakeProfit.Value = 100.0;
		ddTakeProfit.Value = 0.01;
		dExp.ModeTimeShift = 2;
		dExp.TimeShiftDays = 1.0;
		dExp.TimeSkipWeekdays = true;
		// Block input parameters
		VolumeMode = "equityRisk";
		StopLossMode = "dynamicLevel";
		TakeProfitMode = "dynamicLevel";
	}

	public: /* Custom methods */
	virtual double _dVolumeSize_() {return dVolumeSize._execute_();}
	virtual double _dlStopLoss_() {
		dlStopLoss.Value = v::sl_price;

		return dlStopLoss._execute_();
	}
	virtual double _dpStopLoss_() {return dpStopLoss._execute_();}
	virtual double _ddStopLoss_() {return ddStopLoss._execute_();}
	virtual double _dlTakeProfit_() {
		dlTakeProfit.Value = v::tp_price;

		return dlTakeProfit._execute_();
	}
	virtual double _dpTakeProfit_() {return dpTakeProfit._execute_();}
	virtual double _ddTakeProfit_() {return ddTakeProfit._execute_();}
	virtual datetime _dExp_() {return dExp._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[81].run(48);
		}
		else if (value == 1) {
			_blocks_[24].run(48);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		VolumeRisk = (double)v::correct_risk_percent;
		VolumeUpperLimit = (double)c::Maximum_Lot;
		MyComment = (string)v::position_comment;
		ArrowColorSell = (color)clrRed;
	}
};

// Block 188 (Conditionsl line is below Bid)
class Block49: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_prices_prices,double,int>
{

	public: /* Constructor */
	Block49() {
		__block_number = 49;
		__block_user_number = "188";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {47};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Price = "BID";
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::sl_price;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Symbol = CurrentSymbol();

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[47].run(49);
		}
	}
};

// Block 189 (Conditiontp line is above Ask)
class Block50: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_prices_prices,double,int>
{

	public: /* Constructor */
	Block50() {
		__block_number = 50;
		__block_user_number = "189";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {49,51};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::tp_price;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Symbol = CurrentSymbol();

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[51].run(50);
		}
		else if (value == 1) {
			_blocks_[49].run(50);
		}
	}
};

// Block 190 (Conditionsl line is below Bid)
class Block51: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_prices_prices,double,int>
{

	public: /* Constructor */
	Block51() {
		__block_number = 51;
		__block_user_number = "190";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {48};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::sl_price;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Symbol = CurrentSymbol();

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[48].run(51);
		}
	}
};

// Block 191 (close (partially))
class Block52: public MDL_LoopClosePart<string,double,double,ulong,color>
{

	public: /* Constructor */
	Block52() {
		__block_number = 52;
		__block_user_number = "191";
		_beforeExecuteEnabled = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		ArrowColor = (color)clrBlack;
	}
};

// Block 194 (Modify Variablesset risk_percent)
class Block53: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block53() {
		__block_number = 53;
		__block_user_number = "194";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {260,263};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.Value = c::Risk_Percent;

		return Value1._execute_();
	}
	virtual double _Value2_() {
		Value2.Value = v::risk_percent;

		double value = (double)Value2._execute_();
		value = value*v::risk_percent_factor; // Adjust the value
		return value;
	}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[260].run(53);
			_blocks_[263].run(53);
		}
	}

	virtual void _beforeExecute_()
	{

		v::risk_percent = _Value1_();
	}
};

// Block 196 (Custom MQL code)
class Block54: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block54() {
		__block_number = 54;
		__block_user_number = "196";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[3] = {300,57,71};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[57].run(54);
			_blocks_[71].run(54);
			_blocks_[300].run(54);
		}
	}

	virtual void _beforeExecute_()
	{

		int x1 = 20;
    int y1 = 30;
    int x2 = 370;
    int y2 = 420;
    int borderWidth = 2; // Width of the border in pixels
    
    string borderName = "ButtonBorder";
    string bgName = "ButtonBackground";
    color backgroundColor = (color)0x362424; // Dark brown color
	
    // Create and set properties for the border
    ObjectCreate(0, borderName, OBJ_RECTANGLE_LABEL, 0, 0, 0);
    ObjectSetInteger(0, borderName, OBJPROP_XDISTANCE, x1 - borderWidth);
    ObjectSetInteger(0, borderName, OBJPROP_YDISTANCE, y1 - borderWidth);
    ObjectSetInteger(0, borderName, OBJPROP_XSIZE, (x2 - x1) + (2 * borderWidth));
    ObjectSetInteger(0, borderName, OBJPROP_YSIZE, (y2 - y1) + (2 * borderWidth));
    ObjectSetInteger(0, borderName, OBJPROP_BGCOLOR, clrBlack);
    ObjectSetInteger(0, borderName, OBJPROP_BORDER_TYPE, BORDER_FLAT);
    ObjectSetInteger(0, borderName, OBJPROP_CORNER, CORNER_LEFT_UPPER);
    ObjectSetInteger(0, borderName, OBJPROP_ZORDER, 0);
    
    // Create and set properties for the inner background
    ObjectCreate(0, bgName, OBJ_RECTANGLE_LABEL, 0, 0, 0);
    ObjectSetInteger(0, bgName, OBJPROP_XDISTANCE, x1);
    ObjectSetInteger(0, bgName, OBJPROP_YDISTANCE, y1);
    ObjectSetInteger(0, bgName, OBJPROP_XSIZE, x2 - x1);
    ObjectSetInteger(0, bgName, OBJPROP_YSIZE, y2 - y1);
    ObjectSetInteger(0, bgName, OBJPROP_BGCOLOR, backgroundColor);
    ObjectSetInteger(0, bgName, OBJPROP_BORDER_TYPE, BORDER_FLAT);
    ObjectSetInteger(0, bgName, OBJPROP_CORNER, CORNER_LEFT_UPPER);
    ObjectSetInteger(0, bgName, OBJPROP_ZORDER, 1);
	}
};

// Block 197 (Custom MQL code)
class Block55: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block55() {
		__block_number = 55;
		__block_user_number = "197";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {56};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[56].run(55);
		}
	}

	virtual void _beforeExecute_()
	{

		ObjectDelete(0, "ButtonBorder");
ObjectDelete(0, "ButtonBackground");
ObjectDelete(0, "btnRiskFree");
ObjectDelete(0, "btnCloseAll");
ObjectDelete(0, "btnPendingOrder");
ObjectDelete(0, "btnOpenCalc");
ObjectDelete(0, "btnOpenTrade");
ObjectDelete(0, "lineSL");
ObjectDelete(0, "lineTP");
ObjectDelete(0, "linePendingOrder");

ObjectDelete(0, "ButtonBorder");
ObjectDelete(0, "ButtonBackground");
ObjectDelete(0, "btnCloseFull");
ObjectDelete(0, "btnCloseFiftyPercent");
ObjectDelete(0, "btnCloseCustom");
ObjectDelete(0, "btnAutoBreakEven");
ObjectDelete(0, "btnAddPartialTakeProfit");
ObjectDelete(0, "txtPositionComment");
ObjectDelete(0, "txtRiskPercent");
ObjectDelete(0, "btnRiskPlus");
ObjectDelete(0, "btnRiskMinus");
ObjectDelete(0, "lblPercent");
ObjectDelete(0, "lblHeader");
ObjectDelete(0, "btnAutoBreakEvenSet");
ObjectDelete(0, "btnAddPartialTakeProfitSet");
ObjectDelete(0, "lineTP");
ObjectDelete(0, "btnMinimize");
ObjectDelete(0, "lineTP1");
ObjectDelete(0, "lineTP2");
ObjectDelete(0, "lineTP3");
ObjectDelete(0, "lineTP4");
ObjectDelete(0, "lineTP5");
ObjectDelete(0, "lbllineTP1");
ObjectDelete(0, "lbllineTP2");
ObjectDelete(0, "lbllineTP3");
ObjectDelete(0, "lbllineTP4");
ObjectDelete(0, "lbllineTP5");

ObjectDelete(0, "lblLineSL");
ObjectDelete(0, "lblLineTP");

ObjectDelete(0, "lineBEtriger");
ObjectDelete(0, "lineBEtarget");
ObjectDelete(0, "lbllineBEtriger");
ObjectDelete(0, "lbllineBEtarget");
ObjectDelete(0, "lblNote");
	}
};

// Block 198 (Pass)
class Block56: public MDL_Pass
{

	public: /* Constructor */
	Block56() {
		__block_number = 56;
		__block_user_number = "198";

	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}
};

// Block 203 (btnOpenCalc)
class Block57: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block57() {
		__block_number = 57;
		__block_user_number = "203";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {276,58};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[58].run(57);
			_blocks_[276].run(57);
		}
	}

	virtual void _beforeExecute_()
	{

		string name = "btnOpenCalc";

string text =  "Open Calc" ; 
int x = 41;
int y =  95;
int width =  141;
int height =  39;
color bgColor =  (color)0x548718;
color textColor = clrWhite;
int fontSize = 12;
ObjectCreate(0, name, OBJ_BUTTON, 0, 0, 0);
ObjectSetString(0, name, OBJPROP_TEXT, text);
ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
ObjectSetInteger(0, name, OBJPROP_XSIZE, width);
ObjectSetInteger(0, name, OBJPROP_YSIZE, height);
ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
ObjectSetInteger(0, name, OBJPROP_ANCHOR, ANCHOR_LEFT_UPPER);
ObjectSetInteger(0, name, OBJPROP_FONTSIZE, fontSize);
ObjectSetInteger(0, name, OBJPROP_COLOR, textColor);
ObjectSetInteger(0, name, OBJPROP_BGCOLOR, bgColor);
ObjectSetInteger(0, name, OBJPROP_BORDER_COLOR, bgColor);
ObjectSetInteger(0, name, OBJPROP_BACK, false);
ObjectSetInteger(0, name, OBJPROP_STATE, false);
ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
ObjectSetInteger(0, name, OBJPROP_SELECTED, false);
ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
ObjectSetInteger(0, name, OBJPROP_ZORDER, 10);
	}
};

// Block 204 (btnPendingOrder)
class Block58: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block58() {
		__block_number = 58;
		__block_user_number = "204";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {59};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[59].run(58);
		}
	}

	virtual void _beforeExecute_()
	{

		string name = "btnPendingOrder";

string text =  "Pending Order" ; 
int x = 207;
int y =  95;
int width =  141;
int height =  39;
color bgColor =  (color)0x548718;
color textColor = clrWhite;
int fontSize = 12;
ObjectCreate(0, name, OBJ_BUTTON, 0, 0, 0);
ObjectSetString(0, name, OBJPROP_TEXT, text);
ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
ObjectSetInteger(0, name, OBJPROP_XSIZE, width);
ObjectSetInteger(0, name, OBJPROP_YSIZE, height);
ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
ObjectSetInteger(0, name, OBJPROP_ANCHOR, ANCHOR_LEFT_UPPER);
ObjectSetInteger(0, name, OBJPROP_FONTSIZE, fontSize);
ObjectSetInteger(0, name, OBJPROP_COLOR, textColor);
ObjectSetInteger(0, name, OBJPROP_BGCOLOR, bgColor);
ObjectSetInteger(0, name, OBJPROP_BORDER_COLOR, bgColor);
ObjectSetInteger(0, name, OBJPROP_BACK, false);
ObjectSetInteger(0, name, OBJPROP_STATE, false);
ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
ObjectSetInteger(0, name, OBJPROP_SELECTED, false);
ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
ObjectSetInteger(0, name, OBJPROP_ZORDER, 10);
	}
};

// Block 205 (btnOpenPosition)
class Block59: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block59() {
		__block_number = 59;
		__block_user_number = "205";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {60};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[60].run(59);
		}
	}

	virtual void _beforeExecute_()
	{

		string name = "btnOpenTrade";

string text =  "Open Position" ; 
int x = 41;
int y =  141;
int width =  141;
int height =  39;
color bgColor =  (color)0x4635DC;
color textColor = clrWhite;
int fontSize = 12;
ObjectCreate(0, name, OBJ_BUTTON, 0, 0, 0);
ObjectSetString(0, name, OBJPROP_TEXT, text);
ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
ObjectSetInteger(0, name, OBJPROP_XSIZE, width);
ObjectSetInteger(0, name, OBJPROP_YSIZE, height);
ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
ObjectSetInteger(0, name, OBJPROP_ANCHOR, ANCHOR_LEFT_UPPER);
ObjectSetInteger(0, name, OBJPROP_FONTSIZE, fontSize);
ObjectSetInteger(0, name, OBJPROP_COLOR, textColor);
ObjectSetInteger(0, name, OBJPROP_BGCOLOR, bgColor);
ObjectSetInteger(0, name, OBJPROP_BORDER_COLOR, bgColor);
ObjectSetInteger(0, name, OBJPROP_BACK, false);
ObjectSetInteger(0, name, OBJPROP_STATE, false);
ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
ObjectSetInteger(0, name, OBJPROP_SELECTED, false);
ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
ObjectSetInteger(0, name, OBJPROP_ZORDER, 10);
	}
};

// Block 206 (btnCloseFull)
class Block60: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block60() {
		__block_number = 60;
		__block_user_number = "206";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[3] = {61,62,63};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[61].run(60);
			_blocks_[62].run(60);
			_blocks_[63].run(60);
		}
	}

	virtual void _beforeExecute_()
	{

		string name = "btnCloseFull";

string text =  "Close Full" ; 
int x = 41;
int y =  233;
int width =  141;
int height =  39;
color bgColor =  (color)0xFD6E0D;
color textColor = clrWhite;
int fontSize = 12;
ObjectCreate(0, name, OBJ_BUTTON, 0, 0, 0);
ObjectSetString(0, name, OBJPROP_TEXT, text);
ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
ObjectSetInteger(0, name, OBJPROP_XSIZE, width);
ObjectSetInteger(0, name, OBJPROP_YSIZE, height);
ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
ObjectSetInteger(0, name, OBJPROP_ANCHOR, ANCHOR_LEFT_UPPER);
ObjectSetInteger(0, name, OBJPROP_FONTSIZE, fontSize);
ObjectSetInteger(0, name, OBJPROP_COLOR, textColor);
ObjectSetInteger(0, name, OBJPROP_BGCOLOR, bgColor);
ObjectSetInteger(0, name, OBJPROP_BORDER_COLOR, bgColor);
ObjectSetInteger(0, name, OBJPROP_BACK, false);
ObjectSetInteger(0, name, OBJPROP_STATE, false);
ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
ObjectSetInteger(0, name, OBJPROP_SELECTED, false);
ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
ObjectSetInteger(0, name, OBJPROP_ZORDER, 10);
	}
};

// Block 207 (btnCloseCustom)
class Block61: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block61() {
		__block_number = 61;
		__block_user_number = "207";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {128,64};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[64].run(61);
			_blocks_[128].run(61);
		}
	}

	virtual void _beforeExecute_()
	{

		string name = "btnCloseCustom";

string text =  "Close "+ c::Close_Custom_Percent + "%" ; 
int x = 41;
int y =  279;
int width =  141;
int height =  39;
color bgColor =  (color)0xFD6E0D;
color textColor = clrWhite;
int fontSize = 12;
ObjectCreate(0, name, OBJ_BUTTON, 0, 0, 0);
ObjectSetString(0, name, OBJPROP_TEXT, text);
ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
ObjectSetInteger(0, name, OBJPROP_XSIZE, width);
ObjectSetInteger(0, name, OBJPROP_YSIZE, height);
ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
ObjectSetInteger(0, name, OBJPROP_ANCHOR, ANCHOR_LEFT_UPPER);
ObjectSetInteger(0, name, OBJPROP_FONTSIZE, fontSize);
ObjectSetInteger(0, name, OBJPROP_COLOR, textColor);
ObjectSetInteger(0, name, OBJPROP_BGCOLOR, bgColor);
ObjectSetInteger(0, name, OBJPROP_BORDER_COLOR, bgColor);
ObjectSetInteger(0, name, OBJPROP_BACK, false);
ObjectSetInteger(0, name, OBJPROP_STATE, false);
ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
ObjectSetInteger(0, name, OBJPROP_SELECTED, false);
ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
ObjectSetInteger(0, name, OBJPROP_ZORDER, 10);
	}
};

// Block 208 (btnRiskFree)
class Block62: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block62() {
		__block_number = 62;
		__block_user_number = "208";
		_beforeExecuteEnabled = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		string name = "btnRiskFree";

string text =  "Risk Free" ; 
int x = 207;
int y =  279;
int width =  141;
int height =  39;
color bgColor =  (color)0xFD6E0D;
color textColor = clrWhite;
int fontSize = 12;
ObjectCreate(0, name, OBJ_BUTTON, 0, 0, 0);
ObjectSetString(0, name, OBJPROP_TEXT, text);
ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
ObjectSetInteger(0, name, OBJPROP_XSIZE, width);
ObjectSetInteger(0, name, OBJPROP_YSIZE, height);
ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
ObjectSetInteger(0, name, OBJPROP_ANCHOR, ANCHOR_LEFT_UPPER);
ObjectSetInteger(0, name, OBJPROP_FONTSIZE, fontSize);
ObjectSetInteger(0, name, OBJPROP_COLOR, textColor);
ObjectSetInteger(0, name, OBJPROP_BGCOLOR, bgColor);
ObjectSetInteger(0, name, OBJPROP_BORDER_COLOR, bgColor);
ObjectSetInteger(0, name, OBJPROP_BACK, false);
ObjectSetInteger(0, name, OBJPROP_STATE, false);
ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
ObjectSetInteger(0, name, OBJPROP_SELECTED, false);
ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
ObjectSetInteger(0, name, OBJPROP_ZORDER, 10);
	}
};

// Block 209 (btnCloseFiftyPercent)
class Block63: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block63() {
		__block_number = 63;
		__block_user_number = "209";
		_beforeExecuteEnabled = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		string name = "btnCloseFiftyPercent";

string text =  "Close 50%" ; 
int x = 207;
int y =  233;
int width =  141;
int height =  39;
color bgColor =  (color)0xFD6E0D;
color textColor = clrWhite;
int fontSize = 12;
ObjectCreate(0, name, OBJ_BUTTON, 0, 0, 0);
ObjectSetString(0, name, OBJPROP_TEXT, text);
ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
ObjectSetInteger(0, name, OBJPROP_XSIZE, width);
ObjectSetInteger(0, name, OBJPROP_YSIZE, height);
ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
ObjectSetInteger(0, name, OBJPROP_ANCHOR, ANCHOR_LEFT_UPPER);
ObjectSetInteger(0, name, OBJPROP_FONTSIZE, fontSize);
ObjectSetInteger(0, name, OBJPROP_COLOR, textColor);
ObjectSetInteger(0, name, OBJPROP_BGCOLOR, bgColor);
ObjectSetInteger(0, name, OBJPROP_BORDER_COLOR, bgColor);
ObjectSetInteger(0, name, OBJPROP_BACK, false);
ObjectSetInteger(0, name, OBJPROP_STATE, false);
ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
ObjectSetInteger(0, name, OBJPROP_SELECTED, false);
ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
ObjectSetInteger(0, name, OBJPROP_ZORDER, 10);
	}
};

// Block 210 (btnAuto Break Even)
class Block64: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block64() {
		__block_number = 64;
		__block_user_number = "210";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {129,65};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[65].run(64);
			_blocks_[129].run(64);
		}
	}

	virtual void _beforeExecute_()
	{

		string name = "btnAutoBreakEven";

string text =  "Auto Break Even" ; 
int x = 41;
int y =  324;
int width =  240;
int height =  39;
color bgColor =  (color)0x548718;
color textColor = clrWhite;
int fontSize = 12;
ObjectCreate(0, name, OBJ_BUTTON, 0, 0, 0);
ObjectSetString(0, name, OBJPROP_TEXT, text);
ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
ObjectSetInteger(0, name, OBJPROP_XSIZE, width);
ObjectSetInteger(0, name, OBJPROP_YSIZE, height);
ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
ObjectSetInteger(0, name, OBJPROP_ANCHOR, ANCHOR_LEFT_UPPER);
ObjectSetInteger(0, name, OBJPROP_FONTSIZE, fontSize);
ObjectSetInteger(0, name, OBJPROP_COLOR, textColor);
ObjectSetInteger(0, name, OBJPROP_BGCOLOR, bgColor);
ObjectSetInteger(0, name, OBJPROP_BORDER_COLOR, bgColor);
ObjectSetInteger(0, name, OBJPROP_BACK, false);
ObjectSetInteger(0, name, OBJPROP_STATE, false);
ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
ObjectSetInteger(0, name, OBJPROP_SELECTED, false);
ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
ObjectSetInteger(0, name, OBJPROP_ZORDER, 10);
	}
};

// Block 211 (btnAddPartialTakeProfit)
class Block65: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block65() {
		__block_number = 65;
		__block_user_number = "211";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {302,66};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[66].run(65);
			_blocks_[302].run(65);
		}
	}

	virtual void _beforeExecute_()
	{

		string name = "btnAddPartialTakeProfit";

string text =  "Add Partial Take Profit" ; 
int x = 41;
int y =  368;
int width =  240;
int height =  39;
color bgColor =  (color)0xFD6E0D;
color textColor = clrWhite;
int fontSize = 12;
ObjectCreate(0, name, OBJ_BUTTON, 0, 0, 0);
ObjectSetString(0, name, OBJPROP_TEXT, text);
ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
ObjectSetInteger(0, name, OBJPROP_XSIZE, width);
ObjectSetInteger(0, name, OBJPROP_YSIZE, height);
ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
ObjectSetInteger(0, name, OBJPROP_ANCHOR, ANCHOR_LEFT_UPPER);
ObjectSetInteger(0, name, OBJPROP_FONTSIZE, fontSize);
ObjectSetInteger(0, name, OBJPROP_COLOR, textColor);
ObjectSetInteger(0, name, OBJPROP_BGCOLOR, bgColor);
ObjectSetInteger(0, name, OBJPROP_BORDER_COLOR, bgColor);
ObjectSetInteger(0, name, OBJPROP_BACK, false);
ObjectSetInteger(0, name, OBJPROP_STATE, false);
ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
ObjectSetInteger(0, name, OBJPROP_SELECTED, false);
ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
ObjectSetInteger(0, name, OBJPROP_ZORDER, 10);
	}
};

// Block 212 (Draw Comment Edit Field)
class Block66: public MDL_ChartDrawEditField<bool,bool,string,int,int,MDLIC_text_text,string,string,int,int,int,int,color,color,int,bool,color,bool,bool,bool,bool,int,string>
{

	public: /* Constructor */
	Block66() {
		__block_number = 66;
		__block_user_number = "212";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {67};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		ObjText.Text = "";
		// Block input parameters
		ObjName = "txtPositionComment";
		ObjX = 138;
		ObjY = 187;
		ObjFontSize = 12;
		ObjXsize = 211;
		ObjYsize = 39;
		ObjBack = false;
		ObjHidden = true;
		ObjZorder = 1000;
	}

	public: /* Custom methods */
	virtual string _ObjText_() {return ObjText._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[67].run(66);
		}
	}

	virtual void _beforeExecute_()
	{

		ObjAlign = (int)ALIGN_CENTER;
		ObjBgColor = (color)clrWhite;
		ObjBorderColor = (color)clrNONE;
		ObjCorner = (int)CORNER_LEFT_UPPER;
		ObjColor = (color)clrBlack;
	}
};

// Block 213 (Draw Risk percent Edit field)
class Block67: public MDL_ChartDrawEditField<bool,bool,string,int,int,MDLIC_text_text,string,string,int,int,int,int,color,color,int,bool,color,bool,bool,bool,bool,int,string>
{

	public: /* Constructor */
	Block67() {
		__block_number = 67;
		__block_user_number = "213";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {68,70};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		ObjName = "txtRiskPercent";
		ObjX = 207;
		ObjY = 140;
		ObjFontSize = 14;
		ObjXsize = 72;
		ObjYsize = 42;
		ObjBack = false;
		ObjHidden = true;
		ObjZorder = 1000;
	}

	public: /* Custom methods */
	virtual string _ObjText_() {
		ObjText.Text = v::risk_percent;

		return ObjText._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[68].run(67);
			_blocks_[70].run(67);
		}
	}

	virtual void _beforeExecute_()
	{

		ObjAlign = (int)ALIGN_CENTER;
		ObjBgColor = (color)clrWhite;
		ObjBorderColor = (color)clrNONE;
		ObjCorner = (int)CORNER_LEFT_UPPER;
		ObjColor = (color)clrBlack;
	}
};

// Block 214 (btnRiskPlus)
class Block68: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block68() {
		__block_number = 68;
		__block_user_number = "214";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {69};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[69].run(68);
		}
	}

	virtual void _beforeExecute_()
	{

		string name = "btnRiskPlus";

string text =  "+" ; 
int x = 288;
int y =  142;
int width =  18;
int height =  18;
color bgColor =  (color)0x548718;
color textColor = clrWhite;
int fontSize = 12;
ObjectCreate(0, name, OBJ_BUTTON, 0, 0, 0);
ObjectSetString(0, name, OBJPROP_TEXT, text);
ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
ObjectSetInteger(0, name, OBJPROP_XSIZE, width);
ObjectSetInteger(0, name, OBJPROP_YSIZE, height);
ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
ObjectSetInteger(0, name, OBJPROP_ANCHOR, ANCHOR_LEFT_UPPER);
ObjectSetInteger(0, name, OBJPROP_FONTSIZE, fontSize);
ObjectSetInteger(0, name, OBJPROP_COLOR, textColor);
ObjectSetInteger(0, name, OBJPROP_BGCOLOR, bgColor);
ObjectSetInteger(0, name, OBJPROP_BORDER_COLOR, bgColor);
ObjectSetInteger(0, name, OBJPROP_BACK, false);
ObjectSetInteger(0, name, OBJPROP_STATE, false);
ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
ObjectSetInteger(0, name, OBJPROP_SELECTED, false);
ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
ObjectSetInteger(0, name, OBJPROP_ZORDER, 10);
	}
};

// Block 215 (btnRiskMinus)
class Block69: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block69() {
		__block_number = 69;
		__block_user_number = "215";
		_beforeExecuteEnabled = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		string name = "btnRiskMinus";

string text =  "-" ; 
int x = 288;
int y =  162;
int width =  18;
int height =  18;
color bgColor =  (color)0x548718;
color textColor = clrWhite;
int fontSize = 12;
ObjectCreate(0, name, OBJ_BUTTON, 0, 0, 0);
ObjectSetString(0, name, OBJPROP_TEXT, text);
ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
ObjectSetInteger(0, name, OBJPROP_XSIZE, width);
ObjectSetInteger(0, name, OBJPROP_YSIZE, height);
ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
ObjectSetInteger(0, name, OBJPROP_ANCHOR, ANCHOR_LEFT_UPPER);
ObjectSetInteger(0, name, OBJPROP_FONTSIZE, fontSize);
ObjectSetInteger(0, name, OBJPROP_COLOR, textColor);
ObjectSetInteger(0, name, OBJPROP_BGCOLOR, bgColor);
ObjectSetInteger(0, name, OBJPROP_BORDER_COLOR, bgColor);
ObjectSetInteger(0, name, OBJPROP_BACK, false);
ObjectSetInteger(0, name, OBJPROP_STATE, false);
ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
ObjectSetInteger(0, name, OBJPROP_SELECTED, false);
ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
ObjectSetInteger(0, name, OBJPROP_ZORDER, 10);
	}
};

// Block 217 (Draw % Text)
class Block70: public MDL_ChartDrawText<bool,bool,string,ENUM_OBJECT,MDLIC_value_time,datetime,MDLIC_candles_candles,double,int,int,MDLIC_text_text,string,string,int,double,ENUM_BASE_CORNER,int,color,bool,bool,bool,bool,int,string>
{

	public: /* Constructor */
	Block70() {
		__block_number = 70;
		__block_user_number = "217";
		_beforeExecuteEnabled = true;

		// IC input parameters
		ObjTime1.ModeTime = 3;
		ObjTime1.TimeCandleID = 0;
		ObjPrice1.TimeStamp = "";
		ObjText.Text = "%";
		// Block input parameters
		ObjectPerBar = false;
		ObjName = "lblPercent";
		ObjX = 315;
		ObjY = 145;
		ObjFontSize = 16;
		ObjSelectable = false;
		ObjHidden = true;
	}

	public: /* Custom methods */
	virtual datetime _ObjTime1_() {return ObjTime1._execute_();}
	virtual double _ObjPrice1_() {
		ObjPrice1.Symbol = CurrentSymbol();
		ObjPrice1.Period = CurrentTimeframe();

		return ObjPrice1._execute_();
	}
	virtual string _ObjText_() {return ObjText._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		ObjectType = (ENUM_OBJECT)OBJ_LABEL;
		ObjCorner = (ENUM_BASE_CORNER)CORNER_LEFT_UPPER;
		ObjAnchor = (int)ANCHOR_LEFT_UPPER;
		ObjColor = (color)clrWhite;
	}
};

// Block 218 (Draw&nbsp; Header Text)
class Block71: public MDL_ChartDrawText<bool,bool,string,ENUM_OBJECT,MDLIC_value_time,datetime,MDLIC_candles_candles,double,int,int,MDLIC_text_text,string,string,int,double,ENUM_BASE_CORNER,int,color,bool,bool,bool,bool,int,string>
{

	public: /* Constructor */
	Block71() {
		__block_number = 71;
		__block_user_number = "218";
		_beforeExecuteEnabled = true;

		// IC input parameters
		ObjTime1.ModeTime = 3;
		ObjTime1.TimeCandleID = 0;
		ObjPrice1.TimeStamp = "";
		ObjText.Text = "Smartom Trade Assistant";
		// Block input parameters
		ObjectPerBar = false;
		ObjName = "lblHeader";
		ObjX = 41;
		ObjY = 50;
		ObjFont = "Arial Bold";
		ObjFontSize = 13;
		ObjSelectable = false;
	}

	public: /* Custom methods */
	virtual datetime _ObjTime1_() {return ObjTime1._execute_();}
	virtual double _ObjPrice1_() {
		ObjPrice1.Symbol = CurrentSymbol();
		ObjPrice1.Period = CurrentTimeframe();

		return ObjPrice1._execute_();
	}
	virtual string _ObjText_() {return ObjText._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		ObjectType = (ENUM_OBJECT)OBJ_LABEL;
		ObjCorner = (ENUM_BASE_CORNER)CORNER_LEFT_UPPER;
		ObjAnchor = (int)ANCHOR_LEFT_UPPER;
		ObjColor = (color)clrWhite;
      ObjHidden = true;
	}
};

// Block 219 (Mouse clicked on objectbtnRiskPlus)
class Block72: public MDL_eChart_MouseClickObject<string,string>
{

	public: /* Constructor */
	Block72() {
		__block_number = 72;
		__block_user_number = "219";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {73};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		NameFilterMode = "name";
		ObjName = "btnRiskPlus";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[73].run(72);
		}
	}
};

// Block 220 (Formula)
class Block73: public MDL_Formula_9<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block73() {
		__block_number = 73;
		__block_user_number = "220";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {77};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 0.1;
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::risk_percent;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[77].run(73);
		}
	}
};

// Block 221 (Mouse clicked on objectbtnRiskMinus)
class Block74: public MDL_eChart_MouseClickObject<string,string>
{

	public: /* Constructor */
	Block74() {
		__block_number = 74;
		__block_user_number = "221";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {75};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		NameFilterMode = "name";
		ObjName = "btnRiskMinus";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[75].run(74);
		}
	}
};

// Block 222 (Formula)
class Block75: public MDL_Formula_10<MDLIC_value_value,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block75() {
		__block_number = 75;
		__block_user_number = "222";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {76};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 0.1;
		// Block input parameters
		compare = "-";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::risk_percent;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[76].run(75);
		}
	}
};

// Block 223 (Conditionrisk_percent &lt; 0.1)
class Block76: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block76() {
		__block_number = 76;
		__block_user_number = "223";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {77};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 0.1;
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::risk_percent;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[77].run(76);
		}
		else if (value == 1) {
			v::risk_percent = (double)(0.1);
			_blocks_[77].run(76);
		}
	}
};

// Block 224 (update risk percent edit field)
class Block77: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block77() {
		__block_number = 77;
		__block_user_number = "224";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {272};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[272].run(77);
		}
	}

	virtual void _beforeExecute_()
	{

		v::risk_percent = NormalizeDouble(v::risk_percent , 1 );
ObjectSetString(0, "txtRiskPercent", OBJPROP_TEXT, v::risk_percent);
ChartRedraw();
	}
};

// Block 225 (Edit Field modified)
class Block78: public MDL_eChart_LabelEndModify<string,string>
{

	public: /* Constructor */
	Block78() {
		__block_number = 78;
		__block_user_number = "225";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {79};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		NameFilterMode = "name";
		ObjName = "txtRiskPercent";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[79].run(78);
		}
	}
};

// Block 226 (Modify Variables)
class Block79: public MDL_ModifyVariables<int,MDLIC_objectattributes_string,string,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block79() {
		__block_number = 79;
		__block_user_number = "226";
		_beforeExecuteEnabled = true;

		// IC input parameters
		Value1.Name = "txtRiskPercent";
	}

	public: /* Custom methods */
	virtual string _Value1_() {
		Value1.Property = OBJPROP_TEXT;

		return Value1._execute_();
	}
	virtual double _Value2_() {
		Value2.Value = v::risk_percent;

		double value = (double)Value2._execute_();
		value = value*v::risk_percent_factor; // Adjust the value
		return value;
	}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		v::risk_percent = _Value1_();
		v::correct_risk_percent = _Value2_();
	}
};

// Block 228 (Modify Variables)
class Block80: public MDL_ModifyVariables<int,MDLIC_objectattributes_string,string,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block80() {
		__block_number = 80;
		__block_user_number = "228";
		_beforeExecuteEnabled = true;

		// IC input parameters
		Value1.Name = "txtPositionComment";
	}

	public: /* Custom methods */
	virtual string _Value1_() {
		Value1.Property = OBJPROP_TEXT;

		return Value1._execute_();
	}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		v::position_comment = _Value1_();
	}
};

// Block 229 (Alert message)
class Block81: public MDL_AlertMessageAdvanced<string,string,MDLIC_text_text,string,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,bool>
{

	public: /* Constructor */
	Block81() {
		__block_number = 81;
		__block_user_number = "229";


		// IC input parameters
		AlertValue1.Text = "Check meta trader Auto Trading is enable first  and for more information your can check journal tab";
		AlertValue2.Value = 0.0;
		AlertValue3.Value = 0.0;
		AlertValue4.Value = 0.0;
		AlertValue5.Value = 0.0;
		AlertValue6.Value = 0.0;
		AlertValue7.Value = 0.0;
		AlertValue8.Value = 0.0;
		AlertValue9.Value = 0.0;
		AlertValue10.Value = 0.0;
		// Block input parameters
		AlertTitle = "Position Open Error";
		AlertLabel1 = "Error details";
	}

	public: /* Custom methods */
	virtual string _AlertValue1_() {return AlertValue1._execute_();}
	virtual double _AlertValue2_() {return AlertValue2._execute_();}
	virtual double _AlertValue3_() {return AlertValue3._execute_();}
	virtual double _AlertValue4_() {return AlertValue4._execute_();}
	virtual double _AlertValue5_() {return AlertValue5._execute_();}
	virtual double _AlertValue6_() {return AlertValue6._execute_();}
	virtual double _AlertValue7_() {return AlertValue7._execute_();}
	virtual double _AlertValue8_() {return AlertValue8._execute_();}
	virtual double _AlertValue9_() {return AlertValue9._execute_();}
	virtual double _AlertValue10_() {return AlertValue10._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}
};

// Block 230 (Alert message)
class Block82: public MDL_AlertMessageAdvanced<string,string,MDLIC_text_text,string,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,bool>
{

	public: /* Constructor */
	Block82() {
		__block_number = 82;
		__block_user_number = "230";


		// IC input parameters
		AlertValue1.Text = "You should first open position calculator tool with \"OPEN CALC\" button and select position Stop loss and Take profit";
		AlertValue2.Value = 0.0;
		AlertValue3.Value = 0.0;
		AlertValue4.Value = 0.0;
		AlertValue5.Value = 0.0;
		AlertValue6.Value = 0.0;
		AlertValue7.Value = 0.0;
		AlertValue8.Value = 0.0;
		AlertValue9.Value = 0.0;
		AlertValue10.Value = 0.0;
		// Block input parameters
		AlertTitle = "First open positon calculator";
		AlertLabel1 = "Error details";
	}

	public: /* Custom methods */
	virtual string _AlertValue1_() {return AlertValue1._execute_();}
	virtual double _AlertValue2_() {return AlertValue2._execute_();}
	virtual double _AlertValue3_() {return AlertValue3._execute_();}
	virtual double _AlertValue4_() {return AlertValue4._execute_();}
	virtual double _AlertValue5_() {return AlertValue5._execute_();}
	virtual double _AlertValue6_() {return AlertValue6._execute_();}
	virtual double _AlertValue7_() {return AlertValue7._execute_();}
	virtual double _AlertValue8_() {return AlertValue8._execute_();}
	virtual double _AlertValue9_() {return AlertValue9._execute_();}
	virtual double _AlertValue10_() {return AlertValue10._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}
};

// Block 231 (Conditioncalc is open)
class Block83: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_boolean_boolean,bool,int>
{

	public: /* Constructor */
	Block83() {
		__block_number = 83;
		__block_user_number = "231";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {41,82};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual bool _Lo_() {
		Lo.Boolean = v::cal_is_open;

		return Lo._execute_();
	}
	virtual bool _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[82].run(83);
		}
		else if (value == 1) {
			_blocks_[41].run(83);
		}
	}
};

// Block 232 (Mouse clicked on objectbtnCloseFull)
class Block84: public MDL_eChart_MouseClickObject<string,string>
{

	public: /* Constructor */
	Block84() {
		__block_number = 84;
		__block_user_number = "232";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {85};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		NameFilterMode = "name";
		ObjName = "btnCloseFull";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[85].run(84);
		}
	}
};

// Block 233 (Close positions)
class Block85: public MDL_CloseOpened<string,string,string,string,string,int,ulong,color>
{

	public: /* Constructor */
	Block85() {
		__block_number = 85;
		__block_user_number = "233";
		_beforeExecuteEnabled = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
		ArrowColor = (color)clrDeepPink;
	}
};

// Block 392 (Mouse clicked on objectbtnCloseFiftyPercent)
class Block86: public MDL_eChart_MouseClickObject<string,string>
{

	public: /* Constructor */
	Block86() {
		__block_number = 86;
		__block_user_number = "392";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {87};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		NameFilterMode = "name";
		ObjName = "btnCloseFiftyPercent";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[87].run(86);
		}
	}
};

// Block 393 (For each Position)
class Block87: public MDL_LoopStartTrades<string,string,string,string,string,string,int,int,int,int>
{

	public: /* Constructor */
	Block87() {
		__block_number = 87;
		__block_user_number = "393";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {52};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[52].run(87);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
	}
};

// Block 394 (close (partially))
class Block88: public MDL_LoopClosePart<string,double,double,ulong,color>
{

	public: /* Constructor */
	Block88() {
		__block_number = 88;
		__block_user_number = "394";
		_beforeExecuteEnabled = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		PartVolPercent = (double)c::Close_Custom_Percent;
		ArrowColor = (color)clrBlack;
	}
};

// Block 595 (Mouse clicked on objectbtnCloseCustom)
class Block89: public MDL_eChart_MouseClickObject<string,string>
{

	public: /* Constructor */
	Block89() {
		__block_number = 89;
		__block_user_number = "595";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {90};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		NameFilterMode = "name";
		ObjName = "btnCloseCustom";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[90].run(89);
		}
	}
};

// Block 596 (For each Position)
class Block90: public MDL_LoopStartTrades<string,string,string,string,string,string,int,int,int,int>
{

	public: /* Constructor */
	Block90() {
		__block_number = 90;
		__block_user_number = "596";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {88};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[88].run(90);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
	}
};

// Block 597 (Mouse clicked on objectbtnRiskFree)
class Block91: public MDL_eChart_MouseClickObject<string,string>
{

	public: /* Constructor */
	Block91() {
		__block_number = 91;
		__block_user_number = "597";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {92};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		NameFilterMode = "name";
		ObjName = "btnRiskFree";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[92].run(91);
		}
	}
};

// Block 598 (For each Position)
class Block92: public MDL_LoopStartTrades<string,string,string,string,string,string,int,int,int,int>
{

	public: /* Constructor */
	Block92() {
		__block_number = 92;
		__block_user_number = "598";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {93};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[93].run(92);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
	}
};

// Block 599 (Conditionposition is in profit)
class Block93: public MDL_Condition<MDLIC_inloop_OrderProfit,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block93() {
		__block_number = 93;
		__block_user_number = "599";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {307,94};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 0.0;
	}

	public: /* Custom methods */
	virtual double _Lo_() {return Lo._execute_();}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[94].run(93);
		}
		else if (value == 1) {
			_blocks_[307].run(93);
		}
	}
};

// Block 602 (Alert message)
class Block94: public MDL_AlertMessageAdvanced<string,string,MDLIC_text_text,string,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,bool>
{

	public: /* Constructor */
	Block94() {
		__block_number = 94;
		__block_user_number = "602";


		// IC input parameters
		AlertValue1.Text = "This position is not in profit , so you cant use risk free";
		AlertValue2.Value = 0.0;
		AlertValue3.Value = 0.0;
		AlertValue4.Value = 0.0;
		AlertValue5.Value = 0.0;
		AlertValue6.Value = 0.0;
		AlertValue7.Value = 0.0;
		AlertValue8.Value = 0.0;
		AlertValue9.Value = 0.0;
		AlertValue10.Value = 0.0;
		// Block input parameters
		AlertTitle = "Cant Risk Free";
		AlertLabel1 = "Error detail";
	}

	public: /* Custom methods */
	virtual string _AlertValue1_() {return AlertValue1._execute_();}
	virtual double _AlertValue2_() {return AlertValue2._execute_();}
	virtual double _AlertValue3_() {return AlertValue3._execute_();}
	virtual double _AlertValue4_() {return AlertValue4._execute_();}
	virtual double _AlertValue5_() {return AlertValue5._execute_();}
	virtual double _AlertValue6_() {return AlertValue6._execute_();}
	virtual double _AlertValue7_() {return AlertValue7._execute_();}
	virtual double _AlertValue8_() {return AlertValue8._execute_();}
	virtual double _AlertValue9_() {return AlertValue9._execute_();}
	virtual double _AlertValue10_() {return AlertValue10._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}
};

// Block 607 (Mouse clicked on objectbtnAutoBreakEven)
class Block95: public MDL_eChart_MouseClickObject<string,string>
{

	public: /* Constructor */
	Block95() {
		__block_number = 95;
		__block_user_number = "607";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {126};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		NameFilterMode = "name";
		ObjName = "btnAutoBreakEven";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[126].run(95);
		}
	}
};

// Block 608 (Draw BE target Line)
class Block96: public MDL_ChartDrawLine<bool,bool,string,ENUM_OBJECT,MDLIC_value_time,datetime,MDLIC_value_value,double,MDLIC_value_time,datetime,MDLIC_candles_candles,double,double,bool,bool,bool,color,ENUM_LINE_STYLE,int,bool,bool,bool,bool,int,string>
{

	public: /* Constructor */
	Block96() {
		__block_number = 96;
		__block_user_number = "608";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {131,269};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		ObjTime1.ModeTime = 3;
		ObjTime1.TimeCandleID = 0;
		ObjTime2.ModeTime = 3;
		ObjTime2.TimeCandleID = 10;
		ObjPrice2.CandleID = 10;
		ObjPrice2.TimeStamp = "";
		// Block input parameters
		ObjectPerBar = false;
		ObjName = "lineBEtarget";
		ObjWidth = 3;
		ObjBack = true;
		ObjSelected = true;
		ObjHidden = true;
	}

	public: /* Custom methods */
	virtual datetime _ObjTime1_() {return ObjTime1._execute_();}
	virtual double _ObjPrice1_() {
		ObjPrice1.Value = v::be_target_price;

		return ObjPrice1._execute_();
	}
	virtual datetime _ObjTime2_() {return ObjTime2._execute_();}
	virtual double _ObjPrice2_() {
		ObjPrice2.Symbol = CurrentSymbol();
		ObjPrice2.Period = CurrentTimeframe();

		return ObjPrice2._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[131].run(96);
			_blocks_[269].run(96);
		}
	}

	virtual void _beforeExecute_()
	{

		ObjectType = (ENUM_OBJECT)OBJ_HLINE;
		ObjColor = (color)c::BE_Target_Line_Color;
		ObjStyle = (ENUM_LINE_STYLE)STYLE_SOLID;
	}
};

// Block 609 (Conditionbeak even is open == false)
class Block97: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_boolean_boolean,bool,int>
{

	public: /* Constructor */
	Block97() {
		__block_number = 97;
		__block_user_number = "609";


		// Fill the list of outbound blocks
		int ___outbound_blocks[3] = {103,312,99};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Lo.Boolean = false;
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual bool _Lo_() {return Lo._execute_();}
	virtual bool _Ro_() {
		Ro.Boolean = v::auto_be_is_open;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			v::auto_be_is_open = (bool)(false);
			_blocks_[99].run(97);
			_blocks_[312].run(97);
		}
		else if (value == 1) {
			v::auto_be_is_open = (bool)(true);
			_blocks_[103].run(97);
			_blocks_[312].run(97);
		}
	}
};

// Block 610 (Draw BE triger Line)
class Block98: public MDL_ChartDrawLine<bool,bool,string,ENUM_OBJECT,MDLIC_value_time,datetime,MDLIC_value_value,double,MDLIC_value_time,datetime,MDLIC_candles_candles,double,double,bool,bool,bool,color,ENUM_LINE_STYLE,int,bool,bool,bool,bool,int,string>
{

	public: /* Constructor */
	Block98() {
		__block_number = 98;
		__block_user_number = "610";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {102,270};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		ObjTime1.ModeTime = 3;
		ObjTime1.TimeCandleID = 0;
		ObjTime2.ModeTime = 3;
		ObjTime2.TimeCandleID = 10;
		ObjPrice2.CandleID = 10;
		ObjPrice2.TimeStamp = "";
		// Block input parameters
		ObjectPerBar = false;
		ObjName = "lineBEtriger";
		ObjWidth = 3;
		ObjBack = true;
		ObjSelected = true;
		ObjHidden = true;
	}

	public: /* Custom methods */
	virtual datetime _ObjTime1_() {return ObjTime1._execute_();}
	virtual double _ObjPrice1_() {
		ObjPrice1.Value = v::be_triger_price;

		return ObjPrice1._execute_();
	}
	virtual datetime _ObjTime2_() {return ObjTime2._execute_();}
	virtual double _ObjPrice2_() {
		ObjPrice2.Symbol = CurrentSymbol();
		ObjPrice2.Period = CurrentTimeframe();

		return ObjPrice2._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[102].run(98);
			_blocks_[270].run(98);
		}
	}

	virtual void _beforeExecute_()
	{

		ObjectType = (ENUM_OBJECT)OBJ_HLINE;
		ObjColor = (color)c::BE_Triger_Line_Color;
		ObjStyle = (ENUM_LINE_STYLE)STYLE_SOLID;
	}
};

// Block 611 (Delete BE target line)
class Block99: public MDL_ChartDeleteObjects<string,string,color,string,int,int>
{

	public: /* Constructor */
	Block99() {
		__block_number = 99;
		__block_user_number = "611";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {100};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		NameContains = "lineBEtarget";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[100].run(99);
		}
	}

	virtual void _beforeExecute_()
	{

		ObjColor = (color)EMPTY_VALUE;
	}
};

// Block 612 (Delete BE triger line)
class Block100: public MDL_ChartDeleteObjects<string,string,color,string,int,int>
{

	public: /* Constructor */
	Block100() {
		__block_number = 100;
		__block_user_number = "612";
		_beforeExecuteEnabled = true;
		// Block input parameters
		NameContains = "lineBEtriger";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		ObjColor = (color)EMPTY_VALUE;
	}
};

// Block 613 (Draw&nbsp; BE target Text)
class Block101: public MDL_ChartDrawText<bool,bool,string,ENUM_OBJECT,MDLIC_value_time,datetime,MDLIC_value_value,double,int,int,MDLIC_text_text,string,string,int,double,ENUM_BASE_CORNER,int,color,bool,bool,bool,bool,int,string>
{

	public: /* Constructor */
	Block101() {
		__block_number = 101;
		__block_user_number = "613";
		_beforeExecuteEnabled = true;

		// IC input parameters
		ObjTime1.ModeTime = 3;
		ObjText.Text = "Stop Loss will move here after price cross trigger line";
		// Block input parameters
		ObjectPerBar = false;
		ObjName = "lbllineBEtarget";
	}

	public: /* Custom methods */
	virtual datetime _ObjTime1_() {return ObjTime1._execute_();}
	virtual double _ObjPrice1_() {
		ObjPrice1.Value = v::be_target_price;

		return ObjPrice1._execute_();
	}
	virtual string _ObjText_() {return ObjText._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		ObjectType = (ENUM_OBJECT)OBJ_TEXT;
		ObjCorner = (ENUM_BASE_CORNER)CORNER_LEFT_UPPER;
		ObjAnchor = (int)ANCHOR_RIGHT_UPPER;
		ObjColor = (color)c::BE_Target_Line_Color;
	}
};

// Block 614 (Draw&nbsp; BE triger Text)
class Block102: public MDL_ChartDrawText<bool,bool,string,ENUM_OBJECT,MDLIC_value_time,datetime,MDLIC_value_value,double,int,int,MDLIC_text_text,string,string,int,double,ENUM_BASE_CORNER,int,color,bool,bool,bool,bool,int,string>
{

	public: /* Constructor */
	Block102() {
		__block_number = 102;
		__block_user_number = "614";
		_beforeExecuteEnabled = true;

		// IC input parameters
		ObjTime1.ModeTime = 3;
		ObjText.Text = "Break Even Trigger Price";
		// Block input parameters
		ObjectPerBar = false;
		ObjName = "lbllineBEtriger";
	}

	public: /* Custom methods */
	virtual datetime _ObjTime1_() {return ObjTime1._execute_();}
	virtual double _ObjPrice1_() {
		ObjPrice1.Value = v::be_triger_price;

		return ObjPrice1._execute_();
	}
	virtual string _ObjText_() {return ObjText._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		ObjectType = (ENUM_OBJECT)OBJ_TEXT;
		ObjCorner = (ENUM_BASE_CORNER)CORNER_LEFT_UPPER;
		ObjAnchor = (int)ANCHOR_RIGHT_UPPER;
		ObjColor = (color)c::BE_Triger_Line_Color;
	}
};

// Block 615 (Modify Variables)
class Block103: public MDL_ModifyVariables<int,MDLIC_prices_HighestFromToCandles,double,int,MDLIC_prices_LowestFromToCandles,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block103() {
		__block_number = 103;
		__block_user_number = "615";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {96,98};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.EndBar = 15;
		Value2.EndBar = 15;
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.Symbol = CurrentSymbol();
		Value1.Period = CurrentTimeframe();

		return Value1._execute_();
	}
	virtual double _Value2_() {
		Value2.Symbol = CurrentSymbol();
		Value2.Period = CurrentTimeframe();

		return Value2._execute_();
	}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[96].run(103);
			_blocks_[98].run(103);
		}
	}

	virtual void _beforeExecute_()
	{

		v::be_triger_price = _Value1_();
		v::be_target_price = _Value2_();
	}
};

// Block 616 (BE triger Line dragged)
class Block104: public MDL_eChart_ObjectDrag<string,string>
{

	public: /* Constructor */
	Block104() {
		__block_number = 104;
		__block_user_number = "616";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {105};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		NameFilterMode = "name";
		ObjName = "lineBEtriger";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[105].run(104);
		}
	}
};

// Block 622 (Modify VariablesBE triger price)
class Block105: public MDL_ModifyVariables<int,MDLIC_objectattributes_OBJECT,double,int,MDLIC_boolean_boolean,bool,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block105() {
		__block_number = 105;
		__block_user_number = "622";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {102};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Name = "lineBEtriger";
		Value2.Boolean = false;
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.Property = OBJPROP_PRICE1;

		return Value1._execute_();
	}
	virtual bool _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[102].run(105);
		}
	}

	virtual void _beforeExecute_()
	{

		v::be_triger_price = _Value1_();
	}
};

// Block 623 (BE target Line dragged)
class Block106: public MDL_eChart_ObjectDrag<string,string>
{

	public: /* Constructor */
	Block106() {
		__block_number = 106;
		__block_user_number = "623";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {107};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		NameFilterMode = "name";
		ObjName = "lineBEtarget";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[107].run(106);
		}
	}
};

// Block 629 (Modify VariablesBE target price)
class Block107: public MDL_ModifyVariables<int,MDLIC_objectattributes_OBJECT,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block107() {
		__block_number = 107;
		__block_user_number = "629";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {131};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Name = "lineBEtarget";
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.Property = OBJPROP_PRICE1;

		return Value1._execute_();
	}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[131].run(107);
		}
	}

	virtual void _beforeExecute_()
	{

		v::be_target_price = _Value1_();
	}
};

// Block 630 (Once per tick)
class Block108: public MDL_OncePerTick<string>
{

	public: /* Constructor */
	Block108() {
		__block_number = 108;
		__block_user_number = "630";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {137};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[137].run(108);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
	}
};

// Block 635 (Comment Edit Field modified)
class Block109: public MDL_eChart_LabelEndModify<string,string>
{

	public: /* Constructor */
	Block109() {
		__block_number = 109;
		__block_user_number = "635";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {80};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		NameFilterMode = "name";
		ObjName = "txtPositionComment";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[80].run(109);
		}
	}
};

// Block 636 (Conditioncal_is_open == true)
class Block110: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_boolean_boolean,bool,int>
{

	public: /* Constructor */
	Block110() {
		__block_number = 110;
		__block_user_number = "636";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {15,37};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual bool _Lo_() {return Lo._execute_();}
	virtual bool _Ro_() {
		Ro.Boolean = v::cal_is_open;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[15].run(110);
			_blocks_[37].run(110);
		}
	}
};

// Block 637 (Log message)
class Block111: public MDL_PrintMessage<string>
{

	public: /* Constructor */
	Block111() {
		__block_number = 111;
		__block_user_number = "637";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {114};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[114].run(111);
		}
	}

	virtual void _beforeExecute_()
	{

		PrintText = (string)v::money_for_risk;
	}
};

// Block 638 (Log message)
class Block112: public MDL_PrintMessage<string>
{

	public: /* Constructor */
	Block112() {
		__block_number = 112;
		__block_user_number = "638";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {111};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		PrintText = "Money for risk";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[111].run(112);
		}
	}
};

// Block 639 (Log message)
class Block113: public MDL_PrintMessage<string>
{

	public: /* Constructor */
	Block113() {
		__block_number = 113;
		__block_user_number = "639";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {116};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[116].run(113);
		}
	}

	virtual void _beforeExecute_()
	{

		PrintText = (string)v::money_at_risk;
	}
};

// Block 640 (Log message)
class Block114: public MDL_PrintMessage<string>
{

	public: /* Constructor */
	Block114() {
		__block_number = 114;
		__block_user_number = "640";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {113};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		PrintText = "Money at risk";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[113].run(114);
		}
	}
};

// Block 641 (Log message)
class Block115: public MDL_PrintMessage<string>
{

	public: /* Constructor */
	Block115() {
		__block_number = 115;
		__block_user_number = "641";
		_beforeExecuteEnabled = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		PrintText = (string)v::calculated_volume;
	}
};

// Block 642 (Log message)
class Block116: public MDL_PrintMessage<string>
{

	public: /* Constructor */
	Block116() {
		__block_number = 116;
		__block_user_number = "642";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {115};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		PrintText = "Calculated volume";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[115].run(116);
		}
	}
};

// Block 643 (Log message)
class Block117: public MDL_PrintMessage<string>
{

	public: /* Constructor */
	Block117() {
		__block_number = 117;
		__block_user_number = "643";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {120};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[120].run(117);
		}
	}

	virtual void _beforeExecute_()
	{

		PrintText = (string)v::pip_value;
	}
};

// Block 644 (Log message)
class Block118: public MDL_PrintMessage<string>
{

	public: /* Constructor */
	Block118() {
		__block_number = 118;
		__block_user_number = "644";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {117};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		PrintText = "pip value";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[117].run(118);
		}
	}
};

// Block 645 (Log message)
class Block119: public MDL_PrintMessage<string>
{

	public: /* Constructor */
	Block119() {
		__block_number = 119;
		__block_user_number = "645";
		_beforeExecuteEnabled = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		PrintText = (string)v::sl_distance_pip;
	}
};

// Block 646 (Log message)
class Block120: public MDL_PrintMessage<string>
{

	public: /* Constructor */
	Block120() {
		__block_number = 120;
		__block_user_number = "646";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {119};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		PrintText = "sl distance";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[119].run(120);
		}
	}
};

// Block 647 (Formula)
class Block121: public MDL_Formula_11<MDLIC_inloop_OrderStopLoss,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block121() {
		__block_number = 121;
		__block_user_number = "647";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {123};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Lo.Mode = "pips";
		// Block input parameters
		compare = "/";
	}

	public: /* Custom methods */
	virtual double _Lo_() {return Lo._execute_();}
	virtual double _Ro_() {
		Ro.Value = v::rf_div;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[123].run(121);
		}
	}
};

// Block 649 (close (partially))
class Block122: public MDL_LoopClosePart<string,double,double,ulong,color>
{

	public: /* Constructor */
	Block122() {
		__block_number = 122;
		__block_user_number = "649";
		_beforeExecuteEnabled = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		PartVolPercent = (double)v::rf_div;
		ArrowColor = (color)clrDeepPink;
	}
};

// Block 650 (order is buy)
class Block123: public MDL_LoopCheckType<string,string>
{

	public: /* Constructor */
	Block123() {
		__block_number = 123;
		__block_user_number = "650";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {124,125};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[125].run(123);
		}
		else if (value == 1) {
			_blocks_[124].run(123);
		}
	}
};

// Block 651 (Conditionsl is below open price)
class Block124: public MDL_Condition<MDLIC_inloop_OrderOpenPrice,double,string,MDLIC_inloop_OrderStopLoss,double,int>
{

	public: /* Constructor */
	Block124() {
		__block_number = 124;
		__block_user_number = "651";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {122};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {return Lo._execute_();}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[122].run(124);
		}
	}
};

// Block 652 (Conditionsl is above open price)
class Block125: public MDL_Condition<MDLIC_inloop_OrderOpenPrice,double,string,MDLIC_inloop_OrderStopLoss,double,int>
{

	public: /* Constructor */
	Block125() {
		__block_number = 125;
		__block_user_number = "652";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {122};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {return Lo._execute_();}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[122].run(125);
		}
	}
};

// Block 653 (If position/order)
class Block126: public MDL_IfOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block126() {
		__block_number = 126;
		__block_user_number = "653";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {127,97};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[127].run(126);
		}
		else if (value == 1) {
			_blocks_[97].run(126);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
	}
};

// Block 654 (Alert message)
class Block127: public MDL_AlertMessageAdvanced<string,string,MDLIC_text_text,string,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,bool>
{

	public: /* Constructor */
	Block127() {
		__block_number = 127;
		__block_user_number = "654";


		// IC input parameters
		AlertValue1.Text = "You should first have an position to use this feature";
		AlertValue2.Value = 0.0;
		AlertValue3.Value = 0.0;
		AlertValue4.Value = 0.0;
		AlertValue5.Value = 0.0;
		AlertValue6.Value = 0.0;
		AlertValue7.Value = 0.0;
		AlertValue8.Value = 0.0;
		AlertValue9.Value = 0.0;
		AlertValue10.Value = 0.0;
		// Block input parameters
		AlertLabel1 = "Error details";
	}

	public: /* Custom methods */
	virtual string _AlertValue1_() {return AlertValue1._execute_();}
	virtual double _AlertValue2_() {return AlertValue2._execute_();}
	virtual double _AlertValue3_() {return AlertValue3._execute_();}
	virtual double _AlertValue4_() {return AlertValue4._execute_();}
	virtual double _AlertValue5_() {return AlertValue5._execute_();}
	virtual double _AlertValue6_() {return AlertValue6._execute_();}
	virtual double _AlertValue7_() {return AlertValue7._execute_();}
	virtual double _AlertValue8_() {return AlertValue8._execute_();}
	virtual double _AlertValue9_() {return AlertValue9._execute_();}
	virtual double _AlertValue10_() {return AlertValue10._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}
};

// Block 655 (btnAuto Break Even Set)
class Block128: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block128() {
		__block_number = 128;
		__block_user_number = "655";
		_beforeExecuteEnabled = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		string name = "btnAutoBreakEvenSet";

string text =  "Set" ; 
int x = 289;
int y =  324;
int width =  60;
int height =  39;
color bgColor =  (color)0x548718;
color textColor = clrWhite;
int fontSize = 12;
ObjectCreate(0, name, OBJ_BUTTON, 0, 0, 0);
ObjectSetString(0, name, OBJPROP_TEXT, text);
ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
ObjectSetInteger(0, name, OBJPROP_XSIZE, width);
ObjectSetInteger(0, name, OBJPROP_YSIZE, height);
ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
ObjectSetInteger(0, name, OBJPROP_ANCHOR, ANCHOR_LEFT_UPPER);
ObjectSetInteger(0, name, OBJPROP_FONTSIZE, fontSize);
ObjectSetInteger(0, name, OBJPROP_COLOR, textColor);
ObjectSetInteger(0, name, OBJPROP_BGCOLOR, bgColor);
ObjectSetInteger(0, name, OBJPROP_BORDER_COLOR, bgColor);
ObjectSetInteger(0, name, OBJPROP_BACK, false);
ObjectSetInteger(0, name, OBJPROP_STATE, false);
ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
ObjectSetInteger(0, name, OBJPROP_SELECTED, false);
ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
ObjectSetInteger(0, name, OBJPROP_ZORDER, 10);
	}
};

// Block 656 (btnAddPartialTakeProfitSet)
class Block129: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block129() {
		__block_number = 129;
		__block_user_number = "656";
		_beforeExecuteEnabled = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		string name = "btnAddPartialTakeProfitSet";

string text =  "Set" ; 
int x = 289;
int y =  368;
int width =  60;
int height =  39;
color bgColor =  (color)0xFD6E0D;
color textColor = clrWhite;
int fontSize = 12;
ObjectCreate(0, name, OBJ_BUTTON, 0, 0, 0);
ObjectSetString(0, name, OBJPROP_TEXT, text);
ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
ObjectSetInteger(0, name, OBJPROP_XSIZE, width);
ObjectSetInteger(0, name, OBJPROP_YSIZE, height);
ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
ObjectSetInteger(0, name, OBJPROP_ANCHOR, ANCHOR_LEFT_UPPER);
ObjectSetInteger(0, name, OBJPROP_FONTSIZE, fontSize);
ObjectSetInteger(0, name, OBJPROP_COLOR, textColor);
ObjectSetInteger(0, name, OBJPROP_BGCOLOR, bgColor);
ObjectSetInteger(0, name, OBJPROP_BORDER_COLOR, bgColor);
ObjectSetInteger(0, name, OBJPROP_BACK, false);
ObjectSetInteger(0, name, OBJPROP_STATE, false);
ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
ObjectSetInteger(0, name, OBJPROP_SELECTED, false);
ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
ObjectSetInteger(0, name, OBJPROP_ZORDER, 10);
	}
};

// Block 657 (Draw&nbsp; BE target Text)
class Block130: public MDL_ChartDrawText<bool,bool,string,ENUM_OBJECT,MDLIC_value_time,datetime,MDLIC_value_value,double,int,int,MDLIC_text_text,string,string,int,double,ENUM_BASE_CORNER,int,color,bool,bool,bool,bool,int,string>
{

	public: /* Constructor */
	Block130() {
		__block_number = 130;
		__block_user_number = "657";
		_beforeExecuteEnabled = true;

		// IC input parameters
		ObjTime1.ModeTime = 3;
		ObjText.Text = "Stop Loss will move here after price cross trigger line";
		// Block input parameters
		ObjectPerBar = false;
		ObjName = "lbllineBEtarget";
	}

	public: /* Custom methods */
	virtual datetime _ObjTime1_() {return ObjTime1._execute_();}
	virtual double _ObjPrice1_() {
		ObjPrice1.Value = v::be_target_price;

		return ObjPrice1._execute_();
	}
	virtual string _ObjText_() {return ObjText._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		ObjectType = (ENUM_OBJECT)OBJ_TEXT;
		ObjCorner = (ENUM_BASE_CORNER)CORNER_LEFT_UPPER;
		ObjAnchor = (int)ANCHOR_RIGHT_UPPER;
		ObjColor = (color)c::BE_Target_Line_Color;
	}
};

// Block 658 (Conditionrisk_free_at_auto_be is true)
class Block131: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_boolean_boolean,bool,int>
{

	public: /* Constructor */
	Block131() {
		__block_number = 131;
		__block_user_number = "658";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {101,130};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual bool _Lo_() {return Lo._execute_();}
	virtual bool _Ro_() {
		Ro.Boolean = c::Risk_Free_At_Auto_BE;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[101].run(131);
		}
		else if (value == 1) {
			_blocks_[130].run(131);
		}
	}
};

// Block 659 (Mouse clicked on objectbtnAutoBreakEvenSet)
class Block132: public MDL_eChart_MouseClickObject<string,string>
{

	public: /* Constructor */
	Block132() {
		__block_number = 132;
		__block_user_number = "659";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {133,138};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		NameFilterMode = "name";
		ObjName = "btnAutoBreakEvenSet";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[133].run(132);
			_blocks_[138].run(132);
		}
	}
};

// Block 660 (Custom MQL code)
class Block133: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block133() {
		__block_number = 133;
		__block_user_number = "660";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {134};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[134].run(133);
		}
	}

	virtual void _beforeExecute_()
	{

		ObjectSetInteger(0, "lineBEtarget", OBJPROP_WIDTH, 1);
ObjectSetInteger(0, "lineBEtarget", OBJPROP_SELECTABLE, 0);
ObjectSetInteger(0, "lineBEtarget", OBJPROP_SELECTED, 0);
ObjectSetInteger(0, "lineBEtarget", OBJPROP_STYLE, 2);



ObjectSetInteger(0, "lineBEtriger", OBJPROP_WIDTH, 1);
ObjectSetInteger(0, "lineBEtriger", OBJPROP_SELECTABLE, 0);
ObjectSetInteger(0, "lineBEtriger", OBJPROP_SELECTED, 0);
ObjectSetInteger(0, "lineBEtriger", OBJPROP_STYLE, 2);
	}
};

// Block 661 (Delete BE triger label)
class Block134: public MDL_ChartDeleteObjects<string,string,color,string,int,int>
{

	public: /* Constructor */
	Block134() {
		__block_number = 134;
		__block_user_number = "661";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {135};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		NameContains = "lbllineBEtriger";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[135].run(134);
		}
	}

	virtual void _beforeExecute_()
	{

		ObjColor = (color)EMPTY_VALUE;
	}
};

// Block 662 (Delete BE target label)
class Block135: public MDL_ChartDeleteObjects<string,string,color,string,int,int>
{

	public: /* Constructor */
	Block135() {
		__block_number = 135;
		__block_user_number = "662";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {136};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		NameContains = "lbllineBEtarget";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[136].run(135);
		}
	}

	virtual void _beforeExecute_()
	{

		ObjColor = (color)EMPTY_VALUE;
	}
};

// Block 663 (Set Flag (true-false))
class Block136: public MDL_FlagSetB<string,bool>
{

	public: /* Constructor */
	Block136() {
		__block_number = 136;
		__block_user_number = "663";

		// Block input parameters
		FlagName = "shouldMoveBE";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}
};

// Block 664 (Check Flag (true-false))
class Block137: public MDL_FlagCheckB<string,bool>
{

	public: /* Constructor */
	Block137() {
		__block_number = 137;
		__block_user_number = "664";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {141};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		FlagName = "shouldMoveBE";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[141].run(137);
		}
	}
};

// Block 665 (ConditionBE triger is above price , so its a buy order)
class Block138: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_prices_prices,double,int>
{

	public: /* Constructor */
	Block138() {
		__block_number = 138;
		__block_user_number = "665";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {139,140};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Price = "MID";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::be_triger_price;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Symbol = CurrentSymbol();

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[140].run(138);
		}
		else if (value == 1) {
			_blocks_[139].run(138);
		}
	}
};

// Block 666 (Set Flag (textual))
class Block139: public MDL_FlagSetT<string,string>
{

	public: /* Constructor */
	Block139() {
		__block_number = 139;
		__block_user_number = "666";

		// Block input parameters
		FlagName = "be_order_type";
		FlagValue = "buy";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}
};

// Block 667 (Set Flag (textual))
class Block140: public MDL_FlagSetT<string,string>
{

	public: /* Constructor */
	Block140() {
		__block_number = 140;
		__block_user_number = "667";

		// Block input parameters
		FlagName = "be_order_type";
		FlagValue = "sell";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}
};

// Block 668 (Check Flag (textual)order type is buy)
class Block141: public MDL_FlagCheckT<string,string>
{

	public: /* Constructor */
	Block141() {
		__block_number = 141;
		__block_user_number = "668";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {142,143};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		FlagName = "be_order_type";
		FlagValue = "buy";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[143].run(141);
		}
		else if (value == 1) {
			_blocks_[142].run(141);
		}
	}
};

// Block 669 (Conditionprice corss up from trigger)
class Block142: public MDL_Condition<MDLIC_prices_prices,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block142() {
		__block_number = 142;
		__block_user_number = "669";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {147};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Lo.Price = "MID";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Symbol = CurrentSymbol();

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::be_triger_price;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[147].run(142);
		}
	}
};

// Block 670 (Conditionprice corss down from trigger)
class Block143: public MDL_Condition<MDLIC_prices_prices,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block143() {
		__block_number = 143;
		__block_user_number = "670";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {147};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Lo.Price = "MID";
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Symbol = CurrentSymbol();

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::be_triger_price;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[147].run(143);
		}
	}
};

// Block 671 (For each Position)
class Block144: public MDL_LoopStartTrades<string,string,string,string,string,string,int,int,int,int>
{

	public: /* Constructor */
	Block144() {
		__block_number = 144;
		__block_user_number = "671";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {145,155};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[155].run(144);
		}
		else if (value == 1) {
			_blocks_[145].run(144);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
	}
};

// Block 672 (modify stops)
class Block145: public MDL_LoopModifySLTP<string,MDLIC_value_value,double,string,double,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,double,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,color>
{

	public: /* Constructor */
	Block145() {
		__block_number = 145;
		__block_user_number = "672";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {146,154};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		dPrice.Value = 0.0;
		dpNewStopLoss.Value = 10.0;
		ddNewStopLoss.Value = 0.001;
		fNewTakeProfit.Value = 50.0;
		dpNewTakeProfit.Value = 10.0;
		ddNewTakeProfit.Value = 0.001;
		// Block input parameters
		NewSLmode = "function";
		NewTPmode = "none";
	}

	public: /* Custom methods */
	virtual double _dPrice_() {return dPrice._execute_();}
	virtual double _fNewStopLoss_() {
		fNewStopLoss.Value = v::be_target_price;

		return fNewStopLoss._execute_();
	}
	virtual double _dpNewStopLoss_() {return dpNewStopLoss._execute_();}
	virtual double _ddNewStopLoss_() {return ddNewStopLoss._execute_();}
	virtual double _fNewTakeProfit_() {return fNewTakeProfit._execute_();}
	virtual double _dpNewTakeProfit_() {return dpNewTakeProfit._execute_();}
	virtual double _ddNewTakeProfit_() {return ddNewTakeProfit._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[146].run(145);
			_blocks_[154].run(145);
		}
	}

	virtual void _beforeExecute_()
	{

		LevelColor = (color)clrDeepPink;
	}
};

// Block 673 (Alert message)
class Block146: public MDL_AlertMessageAdvanced<string,string,MDLIC_text_text,string,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,bool>
{

	public: /* Constructor */
	Block146() {
		__block_number = 146;
		__block_user_number = "673";
		_beforeExecuteEnabled = true;

		// IC input parameters
		AlertValue1.Text = "Stop loss moved to selected target";
		AlertValue2.Value = 0.0;
		AlertValue3.Value = 0.0;
		AlertValue4.Value = 0.0;
		AlertValue5.Value = 0.0;
		AlertValue6.Value = 0.0;
		AlertValue7.Value = 0.0;
		AlertValue8.Value = 0.0;
		AlertValue9.Value = 0.0;
		AlertValue10.Value = 0.0;
		// Block input parameters
		AlertTitle = "Stop loss moved";
		AlertLabel1 = "Detail";
	}

	public: /* Custom methods */
	virtual string _AlertValue1_() {return AlertValue1._execute_();}
	virtual double _AlertValue2_() {return AlertValue2._execute_();}
	virtual double _AlertValue3_() {return AlertValue3._execute_();}
	virtual double _AlertValue4_() {return AlertValue4._execute_();}
	virtual double _AlertValue5_() {return AlertValue5._execute_();}
	virtual double _AlertValue6_() {return AlertValue6._execute_();}
	virtual double _AlertValue7_() {return AlertValue7._execute_();}
	virtual double _AlertValue8_() {return AlertValue8._execute_();}
	virtual double _AlertValue9_() {return AlertValue9._execute_();}
	virtual double _AlertValue10_() {return AlertValue10._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		AlsoSendNotification = (bool)c::Send_Phone_Notification;
	}
};

// Block 674 (Set Flag (true-false))
class Block147: public MDL_FlagSetB<string,bool>
{

	public: /* Constructor */
	Block147() {
		__block_number = 147;
		__block_user_number = "674";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {148};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		FlagName = "shouldMoveBE";
		FlagValue = false;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[148].run(147);
		}
	}
};

// Block 675 (Set Flag (textual))
class Block148: public MDL_FlagSetT<string,string>
{

	public: /* Constructor */
	Block148() {
		__block_number = 148;
		__block_user_number = "675";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {144};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		FlagName = "be_order_type";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[144].run(148);
		}
	}
};

// Block 724 (Formula)
class Block149: public MDL_Formula_12<MDLIC_inloop_OrderStopLoss,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block149() {
		__block_number = 149;
		__block_user_number = "724";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {151};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Lo.Mode = "pips";
		// Block input parameters
		compare = "/";
	}

	public: /* Custom methods */
	virtual double _Lo_() {return Lo._execute_();}
	virtual double _Ro_() {
		Ro.Value = v::rf_div;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[151].run(149);
		}
	}
};

// Block 726 (close (partially))
class Block150: public MDL_LoopClosePart<string,double,double,ulong,color>
{

	public: /* Constructor */
	Block150() {
		__block_number = 150;
		__block_user_number = "726";
		_beforeExecuteEnabled = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		PartVolPercent = (double)v::rf_div;
		ArrowColor = (color)clrDeepPink;
	}
};

// Block 727 (order is buy)
class Block151: public MDL_LoopCheckType<string,string>
{

	public: /* Constructor */
	Block151() {
		__block_number = 151;
		__block_user_number = "727";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {152,153};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[153].run(151);
		}
		else if (value == 1) {
			_blocks_[152].run(151);
		}
	}
};

// Block 728 (Conditionsl is below open price)
class Block152: public MDL_Condition<MDLIC_inloop_OrderOpenPrice,double,string,MDLIC_inloop_OrderStopLoss,double,int>
{

	public: /* Constructor */
	Block152() {
		__block_number = 152;
		__block_user_number = "728";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {150};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Lo_() {return Lo._execute_();}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[150].run(152);
		}
	}
};

// Block 729 (Conditionsl is above open price)
class Block153: public MDL_Condition<MDLIC_inloop_OrderOpenPrice,double,string,MDLIC_inloop_OrderStopLoss,double,int>
{

	public: /* Constructor */
	Block153() {
		__block_number = 153;
		__block_user_number = "729";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {150};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {return Lo._execute_();}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[150].run(153);
		}
	}
};

// Block 730 (ConditionBe at risk free is True)
class Block154: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_boolean_boolean,bool,int>
{

	public: /* Constructor */
	Block154() {
		__block_number = 154;
		__block_user_number = "730";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {314};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual bool _Lo_() {
		Lo.Boolean = c::Risk_Free_At_Auto_BE;

		return Lo._execute_();
	}
	virtual bool _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[314].run(154);
		}
	}
};

// Block 734 (Delete BE target line)
class Block155: public MDL_ChartDeleteObjects<string,string,color,string,int,int>
{

	public: /* Constructor */
	Block155() {
		__block_number = 155;
		__block_user_number = "734";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {156};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		NameContains = "lineBEtarget";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[156].run(155);
		}
	}

	virtual void _beforeExecute_()
	{

		ObjColor = (color)EMPTY_VALUE;
	}
};

// Block 735 (Delete BE triger line)
class Block156: public MDL_ChartDeleteObjects<string,string,color,string,int,int>
{

	public: /* Constructor */
	Block156() {
		__block_number = 156;
		__block_user_number = "735";
		_beforeExecuteEnabled = true;
		// Block input parameters
		NameContains = "lineBEtriger";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		ObjColor = (color)EMPTY_VALUE;
	}
};

// Block 736 (Mouse clicked on objectbtnAddPartialTakeProfit)
class Block157: public MDL_eChart_MouseClickObject<string,string>
{

	public: /* Constructor */
	Block157() {
		__block_number = 157;
		__block_user_number = "736";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {158};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		NameFilterMode = "name";
		ObjName = "btnAddPartialTakeProfit";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[158].run(157);
		}
	}
};

// Block 737 (If position/order)
class Block158: public MDL_IfOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block158() {
		__block_number = 158;
		__block_user_number = "737";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {159,160};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[159].run(158);
		}
		else if (value == 1) {
			_blocks_[160].run(158);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
	}
};

// Block 738 (Alert message)
class Block159: public MDL_AlertMessageAdvanced<string,string,MDLIC_text_text,string,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,bool>
{

	public: /* Constructor */
	Block159() {
		__block_number = 159;
		__block_user_number = "738";


		// IC input parameters
		AlertValue1.Text = "You should first have an position to use this feature";
		AlertValue2.Value = 0.0;
		AlertValue3.Value = 0.0;
		AlertValue4.Value = 0.0;
		AlertValue5.Value = 0.0;
		AlertValue6.Value = 0.0;
		AlertValue7.Value = 0.0;
		AlertValue8.Value = 0.0;
		AlertValue9.Value = 0.0;
		AlertValue10.Value = 0.0;
		// Block input parameters
		AlertLabel1 = "Error details";
	}

	public: /* Custom methods */
	virtual string _AlertValue1_() {return AlertValue1._execute_();}
	virtual double _AlertValue2_() {return AlertValue2._execute_();}
	virtual double _AlertValue3_() {return AlertValue3._execute_();}
	virtual double _AlertValue4_() {return AlertValue4._execute_();}
	virtual double _AlertValue5_() {return AlertValue5._execute_();}
	virtual double _AlertValue6_() {return AlertValue6._execute_();}
	virtual double _AlertValue7_() {return AlertValue7._execute_();}
	virtual double _AlertValue8_() {return AlertValue8._execute_();}
	virtual double _AlertValue9_() {return AlertValue9._execute_();}
	virtual double _AlertValue10_() {return AlertValue10._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}
};

// Block 739 (Conditionpartial tp is open == false)
class Block160: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_boolean_boolean,bool,int>
{

	public: /* Constructor */
	Block160() {
		__block_number = 160;
		__block_user_number = "739";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {161,177};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Lo.Boolean = false;
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual bool _Lo_() {return Lo._execute_();}
	virtual bool _Ro_() {
		Ro.Boolean = v::partial_tp_is_open;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			v::partial_tp_is_open = (bool)(false);
			_blocks_[177].run(160);
		}
		else if (value == 1) {
			v::partial_tp_is_open = (bool)(true);
			_blocks_[161].run(160);
		}
	}

	virtual void _beforeExecute_()
	{
		// Set variables (in)
		v::tp1_price = (double)(2);

	}
};

// Block 740 (Modify Variablesset t_high and t_low)
class Block161: public MDL_ModifyVariables<int,MDLIC_prices_HighestFromToCandles,double,int,MDLIC_prices_LowestFromToCandles,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block161() {
		__block_number = 161;
		__block_user_number = "740";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {162};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.EndBar = 20;
		Value2.EndBar = 20;
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.Symbol = CurrentSymbol();
		Value1.Period = CurrentTimeframe();

		return Value1._execute_();
	}
	virtual double _Value2_() {
		Value2.Symbol = CurrentSymbol();
		Value2.Period = CurrentTimeframe();

		return Value2._execute_();
	}
	virtual double _Value3_() {
		Value3.Value = v::t_low;

		return Value3._execute_();
	}
	virtual double _Value4_() {
		Value4.Value = v::t_high;

		return Value4._execute_();
	}
	virtual double _Value5_() {
		Value5.Value = v::t_low;

		double value = (double)Value5._execute_();
		value = value+ ((v::t_high-v::t_low) / 2); // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[162].run(161);
		}
	}

	virtual void _beforeExecute_()
	{

		v::t_high = _Value1_();
		v::t_low = _Value2_();
		v::tp1_price = _Value3_();
		v::tp3_price = _Value4_();
		v::tp2_price = _Value5_();
	}
};

// Block 741 (Modify Variablesset tp4_price and tp5_price)
class Block162: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block162() {
		__block_number = 162;
		__block_user_number = "741";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[5] = {163,164,169,170,171};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.Value = v::tp1_price;

		double value = (double)Value1._execute_();
		value = value+((v::tp2_price - v::tp1_price) / 2 ); // Adjust the value
		return value;
	}
	virtual double _Value2_() {
		Value2.Value = v::tp2_price;

		double value = (double)Value2._execute_();
		value = value+((v::tp3_price - v::tp2_price) / 2 ); // Adjust the value
		return value;
	}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[163].run(162);
			_blocks_[164].run(162);
			_blocks_[169].run(162);
			_blocks_[170].run(162);
			_blocks_[171].run(162);
		}
	}

	virtual void _beforeExecute_()
	{

		v::tp4_price = _Value1_();
		v::tp5_price = _Value2_();
	}
};

// Block 742 (ConditionTP2_Percent != 0)
class Block163: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block163() {
		__block_number = 163;
		__block_user_number = "742";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {165};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 0.0;
		// Block input parameters
		compare = "!=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = c::TP2_Percent;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[165].run(163);
		}
	}
};

// Block 743 (Draw TP1 Line)
class Block164: public MDL_ChartDrawLine<bool,bool,string,ENUM_OBJECT,MDLIC_value_time,datetime,MDLIC_value_value,double,MDLIC_value_time,datetime,MDLIC_candles_candles,double,double,bool,bool,bool,color,ENUM_LINE_STYLE,int,bool,bool,bool,bool,int,string>
{

	public: /* Constructor */
	Block164() {
		__block_number = 164;
		__block_user_number = "743";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {172};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		ObjTime1.ModeTime = 3;
		ObjTime1.TimeCandleID = 0;
		ObjTime2.ModeTime = 3;
		ObjTime2.TimeCandleID = 10;
		ObjPrice2.CandleID = 10;
		ObjPrice2.TimeStamp = "";
		// Block input parameters
		ObjectPerBar = false;
		ObjName = "lineTP1";
		ObjWidth = 3;
		ObjBack = true;
		ObjSelected = true;
		ObjHidden = true;
	}

	public: /* Custom methods */
	virtual datetime _ObjTime1_() {return ObjTime1._execute_();}
	virtual double _ObjPrice1_() {
		ObjPrice1.Value = v::tp1_price;

		return ObjPrice1._execute_();
	}
	virtual datetime _ObjTime2_() {return ObjTime2._execute_();}
	virtual double _ObjPrice2_() {
		ObjPrice2.Symbol = CurrentSymbol();
		ObjPrice2.Period = CurrentTimeframe();

		return ObjPrice2._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[172].run(164);
		}
	}

	virtual void _beforeExecute_()
	{

		ObjectType = (ENUM_OBJECT)OBJ_HLINE;
		ObjColor = (color)c::Partial_TP_Line_Color;
		ObjStyle = (ENUM_LINE_STYLE)STYLE_SOLID;
	}
};

// Block 744 (Draw TP2 Line)
class Block165: public MDL_ChartDrawLine<bool,bool,string,ENUM_OBJECT,MDLIC_value_time,datetime,MDLIC_value_value,double,MDLIC_value_time,datetime,MDLIC_candles_candles,double,double,bool,bool,bool,color,ENUM_LINE_STYLE,int,bool,bool,bool,bool,int,string>
{

	public: /* Constructor */
	Block165() {
		__block_number = 165;
		__block_user_number = "744";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {176};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		ObjTime1.ModeTime = 3;
		ObjTime1.TimeCandleID = 0;
		ObjTime2.ModeTime = 3;
		ObjTime2.TimeCandleID = 10;
		ObjPrice2.CandleID = 10;
		ObjPrice2.TimeStamp = "";
		// Block input parameters
		ObjectPerBar = false;
		ObjName = "lineTP2";
		ObjWidth = 3;
		ObjBack = true;
		ObjSelected = true;
		ObjHidden = true;
	}

	public: /* Custom methods */
	virtual datetime _ObjTime1_() {return ObjTime1._execute_();}
	virtual double _ObjPrice1_() {
		ObjPrice1.Value = v::tp2_price;

		return ObjPrice1._execute_();
	}
	virtual datetime _ObjTime2_() {return ObjTime2._execute_();}
	virtual double _ObjPrice2_() {
		ObjPrice2.Symbol = CurrentSymbol();
		ObjPrice2.Period = CurrentTimeframe();

		return ObjPrice2._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[176].run(165);
		}
	}

	virtual void _beforeExecute_()
	{

		ObjectType = (ENUM_OBJECT)OBJ_HLINE;
		ObjColor = (color)c::Partial_TP_Line_Color;
		ObjStyle = (ENUM_LINE_STYLE)STYLE_SOLID;
	}
};

// Block 745 (Draw TP3 Line)
class Block166: public MDL_ChartDrawLine<bool,bool,string,ENUM_OBJECT,MDLIC_value_time,datetime,MDLIC_value_value,double,MDLIC_value_time,datetime,MDLIC_candles_candles,double,double,bool,bool,bool,color,ENUM_LINE_STYLE,int,bool,bool,bool,bool,int,string>
{

	public: /* Constructor */
	Block166() {
		__block_number = 166;
		__block_user_number = "745";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {173};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		ObjTime1.ModeTime = 3;
		ObjTime1.TimeCandleID = 0;
		ObjTime2.ModeTime = 3;
		ObjTime2.TimeCandleID = 10;
		ObjPrice2.CandleID = 10;
		ObjPrice2.TimeStamp = "";
		// Block input parameters
		ObjectPerBar = false;
		ObjName = "lineTP3";
		ObjWidth = 3;
		ObjBack = true;
		ObjSelected = true;
		ObjHidden = true;
	}

	public: /* Custom methods */
	virtual datetime _ObjTime1_() {return ObjTime1._execute_();}
	virtual double _ObjPrice1_() {
		ObjPrice1.Value = v::tp3_price;

		return ObjPrice1._execute_();
	}
	virtual datetime _ObjTime2_() {return ObjTime2._execute_();}
	virtual double _ObjPrice2_() {
		ObjPrice2.Symbol = CurrentSymbol();
		ObjPrice2.Period = CurrentTimeframe();

		return ObjPrice2._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[173].run(166);
		}
	}

	virtual void _beforeExecute_()
	{

		ObjectType = (ENUM_OBJECT)OBJ_HLINE;
		ObjColor = (color)c::Partial_TP_Line_Color;
		ObjStyle = (ENUM_LINE_STYLE)STYLE_SOLID;
	}
};

// Block 746 (Draw TP4 Line)
class Block167: public MDL_ChartDrawLine<bool,bool,string,ENUM_OBJECT,MDLIC_value_time,datetime,MDLIC_value_value,double,MDLIC_value_time,datetime,MDLIC_candles_candles,double,double,bool,bool,bool,color,ENUM_LINE_STYLE,int,bool,bool,bool,bool,int,string>
{

	public: /* Constructor */
	Block167() {
		__block_number = 167;
		__block_user_number = "746";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {175};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		ObjTime1.ModeTime = 3;
		ObjTime1.TimeCandleID = 0;
		ObjTime2.ModeTime = 3;
		ObjTime2.TimeCandleID = 10;
		ObjPrice2.CandleID = 10;
		ObjPrice2.TimeStamp = "";
		// Block input parameters
		ObjectPerBar = false;
		ObjName = "lineTP4";
		ObjWidth = 3;
		ObjBack = true;
		ObjSelected = true;
		ObjHidden = true;
	}

	public: /* Custom methods */
	virtual datetime _ObjTime1_() {return ObjTime1._execute_();}
	virtual double _ObjPrice1_() {
		ObjPrice1.Value = v::tp4_price;

		return ObjPrice1._execute_();
	}
	virtual datetime _ObjTime2_() {return ObjTime2._execute_();}
	virtual double _ObjPrice2_() {
		ObjPrice2.Symbol = CurrentSymbol();
		ObjPrice2.Period = CurrentTimeframe();

		return ObjPrice2._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[175].run(167);
		}
	}

	virtual void _beforeExecute_()
	{

		ObjectType = (ENUM_OBJECT)OBJ_HLINE;
		ObjColor = (color)c::Partial_TP_Line_Color;
		ObjStyle = (ENUM_LINE_STYLE)STYLE_SOLID;
	}
};

// Block 747 (Draw TP5 Line)
class Block168: public MDL_ChartDrawLine<bool,bool,string,ENUM_OBJECT,MDLIC_value_time,datetime,MDLIC_value_value,double,MDLIC_value_time,datetime,MDLIC_candles_candles,double,double,bool,bool,bool,color,ENUM_LINE_STYLE,int,bool,bool,bool,bool,int,string>
{

	public: /* Constructor */
	Block168() {
		__block_number = 168;
		__block_user_number = "747";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {174};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		ObjTime1.ModeTime = 3;
		ObjTime1.TimeCandleID = 0;
		ObjTime2.ModeTime = 3;
		ObjTime2.TimeCandleID = 10;
		ObjPrice2.CandleID = 10;
		ObjPrice2.TimeStamp = "";
		// Block input parameters
		ObjectPerBar = false;
		ObjName = "lineTP5";
		ObjWidth = 3;
		ObjBack = true;
		ObjSelected = true;
		ObjHidden = true;
	}

	public: /* Custom methods */
	virtual datetime _ObjTime1_() {return ObjTime1._execute_();}
	virtual double _ObjPrice1_() {
		ObjPrice1.Value = v::tp5_price;

		return ObjPrice1._execute_();
	}
	virtual datetime _ObjTime2_() {return ObjTime2._execute_();}
	virtual double _ObjPrice2_() {
		ObjPrice2.Symbol = CurrentSymbol();
		ObjPrice2.Period = CurrentTimeframe();

		return ObjPrice2._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[174].run(168);
		}
	}

	virtual void _beforeExecute_()
	{

		ObjectType = (ENUM_OBJECT)OBJ_HLINE;
		ObjColor = (color)c::Partial_TP_Line_Color;
		ObjStyle = (ENUM_LINE_STYLE)STYLE_SOLID;
	}
};

// Block 748 (ConditionTP3_Percent != 0)
class Block169: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block169() {
		__block_number = 169;
		__block_user_number = "748";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {166};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 0.0;
		// Block input parameters
		compare = "!=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = c::TP3_Percent;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[166].run(169);
		}
	}
};

// Block 749 (ConditionTP4_Percent != 0)
class Block170: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block170() {
		__block_number = 170;
		__block_user_number = "749";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {167};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 0.0;
		// Block input parameters
		compare = "!=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = c::TP4_Percent;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[167].run(170);
		}
	}
};

// Block 750 (ConditionTP5_Percent != 0)
class Block171: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block171() {
		__block_number = 171;
		__block_user_number = "750";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {168};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 0.0;
		// Block input parameters
		compare = "!=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = c::TP5_Percent;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[168].run(171);
		}
	}
};

// Block 751 (Draw&nbsp; TP line Text)
class Block172: public MDL_ChartDrawText<bool,bool,string,ENUM_OBJECT,MDLIC_value_time,datetime,MDLIC_value_value,double,int,int,MDLIC_text_text,string,string,int,double,ENUM_BASE_CORNER,int,color,bool,bool,bool,bool,int,string>
{

	public: /* Constructor */
	Block172() {
		__block_number = 172;
		__block_user_number = "751";
		_beforeExecuteEnabled = true;

		// IC input parameters
		ObjTime1.ModeTime = 3;
		// Block input parameters
		ObjectPerBar = false;
		ObjName = "lbllineTP1";
		ObjSelectable = false;
	}

	public: /* Custom methods */
	virtual datetime _ObjTime1_() {return ObjTime1._execute_();}
	virtual double _ObjPrice1_() {
		ObjPrice1.Value = v::tp1_price;

		return ObjPrice1._execute_();
	}
	virtual string _ObjText_() {
		ObjText.Text = "TP1 Close " + c::TP1_Percent + " Percent ";

		return ObjText._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		ObjectType = (ENUM_OBJECT)OBJ_TEXT;
		ObjCorner = (ENUM_BASE_CORNER)CORNER_LEFT_UPPER;
		ObjAnchor = (int)ANCHOR_RIGHT_UPPER;
		ObjColor = (color)c::Partial_TP_Line_Color;
	}
};

// Block 752 (Draw&nbsp; TP line Text)
class Block173: public MDL_ChartDrawText<bool,bool,string,ENUM_OBJECT,MDLIC_value_time,datetime,MDLIC_value_value,double,int,int,MDLIC_text_text,string,string,int,double,ENUM_BASE_CORNER,int,color,bool,bool,bool,bool,int,string>
{

	public: /* Constructor */
	Block173() {
		__block_number = 173;
		__block_user_number = "752";
		_beforeExecuteEnabled = true;

		// IC input parameters
		ObjTime1.ModeTime = 3;
		ObjText.Text = "";
		// Block input parameters
		ObjectPerBar = false;
		ObjName = "lbllineTP3";
		ObjSelectable = false;
	}

	public: /* Custom methods */
	virtual datetime _ObjTime1_() {return ObjTime1._execute_();}
	virtual double _ObjPrice1_() {
		ObjPrice1.Value = v::tp3_price;

		return ObjPrice1._execute_();
	}
	virtual string _ObjText_() {		string value = (string)ObjText._execute_();
		value = value+"TP3 Close " + c::TP3_Percent + " Percent "; // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		ObjectType = (ENUM_OBJECT)OBJ_TEXT;
		ObjCorner = (ENUM_BASE_CORNER)CORNER_LEFT_UPPER;
		ObjAnchor = (int)ANCHOR_RIGHT_UPPER;
		ObjColor = (color)c::Partial_TP_Line_Color;
	}
};

// Block 753 (Draw&nbsp; TP line Text)
class Block174: public MDL_ChartDrawText<bool,bool,string,ENUM_OBJECT,MDLIC_value_time,datetime,MDLIC_value_value,double,int,int,MDLIC_text_text,string,string,int,double,ENUM_BASE_CORNER,int,color,bool,bool,bool,bool,int,string>
{

	public: /* Constructor */
	Block174() {
		__block_number = 174;
		__block_user_number = "753";
		_beforeExecuteEnabled = true;

		// IC input parameters
		ObjTime1.ModeTime = 3;
		ObjText.Text = "";
		// Block input parameters
		ObjectPerBar = false;
		ObjName = "lbllineTP5";
		ObjSelectable = false;
	}

	public: /* Custom methods */
	virtual datetime _ObjTime1_() {return ObjTime1._execute_();}
	virtual double _ObjPrice1_() {
		ObjPrice1.Value = v::tp5_price;

		return ObjPrice1._execute_();
	}
	virtual string _ObjText_() {		string value = (string)ObjText._execute_();
		value = value+"TP5 Close " + c::TP5_Percent + " Percent "; // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		ObjectType = (ENUM_OBJECT)OBJ_TEXT;
		ObjCorner = (ENUM_BASE_CORNER)CORNER_LEFT_UPPER;
		ObjAnchor = (int)ANCHOR_RIGHT_UPPER;
		ObjColor = (color)c::Partial_TP_Line_Color;
	}
};

// Block 754 (Draw&nbsp; TP line Text)
class Block175: public MDL_ChartDrawText<bool,bool,string,ENUM_OBJECT,MDLIC_value_time,datetime,MDLIC_value_value,double,int,int,MDLIC_text_text,string,string,int,double,ENUM_BASE_CORNER,int,color,bool,bool,bool,bool,int,string>
{

	public: /* Constructor */
	Block175() {
		__block_number = 175;
		__block_user_number = "754";
		_beforeExecuteEnabled = true;

		// IC input parameters
		ObjTime1.ModeTime = 3;
		ObjText.Text = "";
		// Block input parameters
		ObjectPerBar = false;
		ObjName = "lbllineTP4";
		ObjSelectable = false;
	}

	public: /* Custom methods */
	virtual datetime _ObjTime1_() {return ObjTime1._execute_();}
	virtual double _ObjPrice1_() {
		ObjPrice1.Value = v::tp4_price;

		return ObjPrice1._execute_();
	}
	virtual string _ObjText_() {		string value = (string)ObjText._execute_();
		value = value+"TP4 Close " + c::TP4_Percent + " Percent "; // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		ObjectType = (ENUM_OBJECT)OBJ_TEXT;
		ObjCorner = (ENUM_BASE_CORNER)CORNER_LEFT_UPPER;
		ObjAnchor = (int)ANCHOR_RIGHT_UPPER;
		ObjColor = (color)c::Partial_TP_Line_Color;
	}
};

// Block 755 (Draw&nbsp; TP line Text)
class Block176: public MDL_ChartDrawText<bool,bool,string,ENUM_OBJECT,MDLIC_value_time,datetime,MDLIC_value_value,double,int,int,MDLIC_text_text,string,string,int,double,ENUM_BASE_CORNER,int,color,bool,bool,bool,bool,int,string>
{

	public: /* Constructor */
	Block176() {
		__block_number = 176;
		__block_user_number = "755";
		_beforeExecuteEnabled = true;

		// IC input parameters
		ObjTime1.ModeTime = 3;
		ObjText.Text = "";
		// Block input parameters
		ObjectPerBar = false;
		ObjName = "lbllineTP2";
		ObjSelectable = false;
	}

	public: /* Custom methods */
	virtual datetime _ObjTime1_() {return ObjTime1._execute_();}
	virtual double _ObjPrice1_() {
		ObjPrice1.Value = v::tp2_price;

		return ObjPrice1._execute_();
	}
	virtual string _ObjText_() {		string value = (string)ObjText._execute_();
		value = value+"TP2 Close " + c::TP2_Percent + " Percent "; // Adjust the value
		return value;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		ObjectType = (ENUM_OBJECT)OBJ_TEXT;
		ObjCorner = (ENUM_BASE_CORNER)CORNER_LEFT_UPPER;
		ObjAnchor = (int)ANCHOR_RIGHT_UPPER;
		ObjColor = (color)c::Partial_TP_Line_Color;
	}
};

// Block 756 (Delete tp target lines)
class Block177: public MDL_ChartDeleteObjects<string,string,color,string,int,int>
{

	public: /* Constructor */
	Block177() {
		__block_number = 177;
		__block_user_number = "756";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {311};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		NameContains = "lineTP1";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[311].run(177);
		}
	}

	virtual void _beforeExecute_()
	{

		ObjColor = (color)EMPTY_VALUE;
	}
};

// Block 757 (TP 1 Line dragged)
class Block178: public MDL_eChart_ObjectDrag<string,string>
{

	public: /* Constructor */
	Block178() {
		__block_number = 178;
		__block_user_number = "757";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {179};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		NameFilterMode = "name";
		ObjName = "lineTP1";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[179].run(178);
		}
	}
};

// Block 758 (Modify VariablesTP1 price)
class Block179: public MDL_ModifyVariables<int,MDLIC_objectattributes_OBJECT,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block179() {
		__block_number = 179;
		__block_user_number = "758";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {172};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Name = "lineTP1";
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.Property = OBJPROP_PRICE1;

		return Value1._execute_();
	}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[172].run(179);
		}
	}

	virtual void _beforeExecute_()
	{

		v::tp1_price = _Value1_();
	}
};

// Block 759 (TP 2 Line dragged)
class Block180: public MDL_eChart_ObjectDrag<string,string>
{

	public: /* Constructor */
	Block180() {
		__block_number = 180;
		__block_user_number = "759";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {181};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		NameFilterMode = "name";
		ObjName = "lineTP2";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[181].run(180);
		}
	}
};

// Block 760 (Modify VariablesTP1 price)
class Block181: public MDL_ModifyVariables<int,MDLIC_objectattributes_OBJECT,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block181() {
		__block_number = 181;
		__block_user_number = "760";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {176};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Name = "lineTP2";
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.Property = OBJPROP_PRICE1;

		return Value1._execute_();
	}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[176].run(181);
		}
	}

	virtual void _beforeExecute_()
	{

		v::tp2_price = _Value1_();
	}
};

// Block 761 (TP&nbsp; 3 Line dragged)
class Block182: public MDL_eChart_ObjectDrag<string,string>
{

	public: /* Constructor */
	Block182() {
		__block_number = 182;
		__block_user_number = "761";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {183};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		NameFilterMode = "name";
		ObjName = "lineTP3";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[183].run(182);
		}
	}
};

// Block 762 (Modify VariablesTP1 price)
class Block183: public MDL_ModifyVariables<int,MDLIC_objectattributes_OBJECT,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block183() {
		__block_number = 183;
		__block_user_number = "762";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {173};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Name = "lineTP3";
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.Property = OBJPROP_PRICE1;

		return Value1._execute_();
	}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[173].run(183);
		}
	}

	virtual void _beforeExecute_()
	{

		v::tp3_price = _Value1_();
	}
};

// Block 763 (TP 4 Line dragged)
class Block184: public MDL_eChart_ObjectDrag<string,string>
{

	public: /* Constructor */
	Block184() {
		__block_number = 184;
		__block_user_number = "763";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {185};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		NameFilterMode = "name";
		ObjName = "lineTP4";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[185].run(184);
		}
	}
};

// Block 764 (Modify VariablesTP1 price)
class Block185: public MDL_ModifyVariables<int,MDLIC_objectattributes_OBJECT,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block185() {
		__block_number = 185;
		__block_user_number = "764";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {175};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Name = "lineTP4";
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.Property = OBJPROP_PRICE1;

		return Value1._execute_();
	}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[175].run(185);
		}
	}

	virtual void _beforeExecute_()
	{

		v::tp4_price = _Value1_();
	}
};

// Block 765 (TP 5 Line dragged)
class Block186: public MDL_eChart_ObjectDrag<string,string>
{

	public: /* Constructor */
	Block186() {
		__block_number = 186;
		__block_user_number = "765";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {187};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		NameFilterMode = "name";
		ObjName = "lineTP5";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[187].run(186);
		}
	}
};

// Block 766 (Modify VariablesTP1 price)
class Block187: public MDL_ModifyVariables<int,MDLIC_objectattributes_OBJECT,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block187() {
		__block_number = 187;
		__block_user_number = "766";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {174};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Name = "lineTP5";
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.Property = OBJPROP_PRICE1;

		return Value1._execute_();
	}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[174].run(187);
		}
	}

	virtual void _beforeExecute_()
	{

		v::tp5_price = _Value1_();
	}
};

// Block 767 (Mouse clicked on objectbtnAddPartialTakeProfitSet)
class Block188: public MDL_eChart_MouseClickObject<string,string>
{

	public: /* Constructor */
	Block188() {
		__block_number = 188;
		__block_user_number = "767";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {189,192};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		NameFilterMode = "name";
		ObjName = "btnAddPartialTakeProfitSet";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[189].run(188);
			_blocks_[192].run(188);
		}
	}
};

// Block 768 (Custom MQL code)
class Block189: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block189() {
		__block_number = 189;
		__block_user_number = "768";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {190};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[190].run(189);
		}
	}

	virtual void _beforeExecute_()
	{

		ObjectSetInteger(0, "lineTP1", OBJPROP_WIDTH, 1);
ObjectSetInteger(0, "lineTP1", OBJPROP_SELECTABLE, 0);
ObjectSetInteger(0, "lineTP1", OBJPROP_SELECTED, 0);
ObjectSetInteger(0, "lineTP1", OBJPROP_STYLE, 2);



ObjectSetInteger(0, "lineTP2", OBJPROP_WIDTH, 1);
ObjectSetInteger(0, "lineTP2", OBJPROP_SELECTABLE, 0);
ObjectSetInteger(0, "lineTP2", OBJPROP_SELECTED, 0);
ObjectSetInteger(0, "lineTP2", OBJPROP_STYLE, 2);

ObjectSetInteger(0, "lineTP3", OBJPROP_WIDTH, 1);
ObjectSetInteger(0, "lineTP3", OBJPROP_SELECTABLE, 0);
ObjectSetInteger(0, "lineTP3", OBJPROP_SELECTED, 0);
ObjectSetInteger(0, "lineTP3", OBJPROP_STYLE, 2);

ObjectSetInteger(0, "lineTP4", OBJPROP_WIDTH, 1);
ObjectSetInteger(0, "lineTP4", OBJPROP_SELECTABLE, 0);
ObjectSetInteger(0, "lineTP4", OBJPROP_SELECTED, 0);
ObjectSetInteger(0, "lineTP4", OBJPROP_STYLE, 2);

ObjectSetInteger(0, "lineTP5", OBJPROP_WIDTH, 1);
ObjectSetInteger(0, "lineTP5", OBJPROP_SELECTABLE, 0);
ObjectSetInteger(0, "lineTP5", OBJPROP_SELECTED, 0);
ObjectSetInteger(0, "lineTP5", OBJPROP_STYLE, 2);
	}
};

// Block 769 (Delete BE triger label)
class Block190: public MDL_ChartDeleteObjects<string,string,color,string,int,int>
{

	public: /* Constructor */
	Block190() {
		__block_number = 190;
		__block_user_number = "769";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {191};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		NameContains = "lbllineTP";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[191].run(190);
		}
	}

	virtual void _beforeExecute_()
	{

		ObjColor = (color)EMPTY_VALUE;
	}
};

// Block 771 (Set Flag (true-false))
class Block191: public MDL_FlagSetB<string,bool>
{

	public: /* Constructor */
	Block191() {
		__block_number = 191;
		__block_user_number = "771";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {249};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		FlagName = "shouldTakeProfit";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[249].run(191);
		}
	}
};

// Block 773 (Conditiontp line is above price , so its a buy order)
class Block192: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_prices_prices,double,int>
{

	public: /* Constructor */
	Block192() {
		__block_number = 192;
		__block_user_number = "773";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {193,194};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Price = "MID";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::tp1_price;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Symbol = CurrentSymbol();

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[194].run(192);
		}
		else if (value == 1) {
			_blocks_[193].run(192);
		}
	}
};

// Block 774 (Set Flag (textual))
class Block193: public MDL_FlagSetT<string,string>
{

	public: /* Constructor */
	Block193() {
		__block_number = 193;
		__block_user_number = "774";

		// Block input parameters
		FlagName = "tp_order_type";
		FlagValue = "buy";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}
};

// Block 775 (Set Flag (textual))
class Block194: public MDL_FlagSetT<string,string>
{

	public: /* Constructor */
	Block194() {
		__block_number = 194;
		__block_user_number = "775";

		// Block input parameters
		FlagName = "tp_order_type";
		FlagValue = "sell";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}
};

// Block 776 (Once per tick)
class Block195: public MDL_OncePerTick<string>
{

	public: /* Constructor */
	Block195() {
		__block_number = 195;
		__block_user_number = "776";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {196};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[196].run(195);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
	}
};

// Block 810 (Check Flag (true-false))
class Block196: public MDL_FlagCheckB<string,bool>
{

	public: /* Constructor */
	Block196() {
		__block_number = 196;
		__block_user_number = "810";


		// Fill the list of outbound blocks
		int ___outbound_blocks[5] = {232,233,234,235,239};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		FlagName = "shouldTakeProfit";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[232].run(196);
			_blocks_[233].run(196);
			_blocks_[234].run(196);
			_blocks_[235].run(196);
			_blocks_[239].run(196);
		}
	}
};

// Block 814 (Check Flag (textual)order type is buy)
class Block197: public MDL_FlagCheckT<string,string>
{

	public: /* Constructor */
	Block197() {
		__block_number = 197;
		__block_user_number = "814";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {198,199};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		FlagName = "tp_order_type";
		FlagValue = "buy";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[199].run(197);
		}
		else if (value == 1) {
			_blocks_[198].run(197);
		}
	}
};

// Block 815 (Conditionprice corss up from tp)
class Block198: public MDL_Condition<MDLIC_prices_prices,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block198() {
		__block_number = 198;
		__block_user_number = "815";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {240};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Lo.Price = "BID";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Symbol = CurrentSymbol();

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::tp1_price;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[240].run(198);
		}
	}
};

// Block 816 (Conditionprice corss down from tp)
class Block199: public MDL_Condition<MDLIC_prices_prices,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block199() {
		__block_number = 199;
		__block_user_number = "816";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {240};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Symbol = CurrentSymbol();

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::tp1_price;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[240].run(199);
		}
	}
};

// Block 817 (For each Position)
class Block200: public MDL_LoopStartTrades<string,string,string,string,string,string,int,int,int,int>
{

	public: /* Constructor */
	Block200() {
		__block_number = 200;
		__block_user_number = "817";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {202,203};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[202].run(200);
		}
		else if (value == 1) {
			_blocks_[203].run(200);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
	}
};

// Block 879 (Alert message)
class Block201: public MDL_AlertMessageAdvanced<string,string,MDLIC_text_text,string,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,bool>
{

	public: /* Constructor */
	Block201() {
		__block_number = 201;
		__block_user_number = "879";
		_beforeExecuteEnabled = true;

		// IC input parameters
		AlertValue1.Text = "Take profit level 1 hit";
		AlertValue2.Value = 0.0;
		AlertValue3.Value = 0.0;
		AlertValue4.Value = 0.0;
		AlertValue5.Value = 0.0;
		AlertValue6.Value = 0.0;
		AlertValue7.Value = 0.0;
		AlertValue8.Value = 0.0;
		AlertValue9.Value = 0.0;
		AlertValue10.Value = 0.0;
		// Block input parameters
		AlertTitle = "Take profit hit";
		AlertLabel1 = "Detail :";
	}

	public: /* Custom methods */
	virtual string _AlertValue1_() {return AlertValue1._execute_();}
	virtual double _AlertValue2_() {return AlertValue2._execute_();}
	virtual double _AlertValue3_() {return AlertValue3._execute_();}
	virtual double _AlertValue4_() {return AlertValue4._execute_();}
	virtual double _AlertValue5_() {return AlertValue5._execute_();}
	virtual double _AlertValue6_() {return AlertValue6._execute_();}
	virtual double _AlertValue7_() {return AlertValue7._execute_();}
	virtual double _AlertValue8_() {return AlertValue8._execute_();}
	virtual double _AlertValue9_() {return AlertValue9._execute_();}
	virtual double _AlertValue10_() {return AlertValue10._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		AlsoSendNotification = (bool)c::Send_Phone_Notification;
	}
};

// Block 880 (Delete BE target line)
class Block202: public MDL_ChartDeleteObjects<string,string,color,string,int,int>
{

	public: /* Constructor */
	Block202() {
		__block_number = 202;
		__block_user_number = "880";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {201};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		NameContains = "lineTP1";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[201].run(202);
		}
	}

	virtual void _beforeExecute_()
	{

		ObjColor = (color)EMPTY_VALUE;
	}
};

// Block 881 (close (partially))
class Block203: public MDL_LoopClosePart<string,double,double,ulong,color>
{

	public: /* Constructor */
	Block203() {
		__block_number = 203;
		__block_user_number = "881";
		_beforeExecuteEnabled = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		PartVolPercent = (double)c::TP1_Percent;
		ArrowColor = (color)clrDeepPink;
	}
};

// Block 882 (Check Flag (textual)order type is buy)
class Block204: public MDL_FlagCheckT<string,string>
{

	public: /* Constructor */
	Block204() {
		__block_number = 204;
		__block_user_number = "882";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {205,206};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		FlagName = "tp_order_type";
		FlagValue = "buy";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[206].run(204);
		}
		else if (value == 1) {
			_blocks_[205].run(204);
		}
	}
};

// Block 883 (Conditionprice corss up from tp)
class Block205: public MDL_Condition<MDLIC_prices_prices,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block205() {
		__block_number = 205;
		__block_user_number = "883";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {245};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Lo.Price = "BID";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Symbol = CurrentSymbol();

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::tp2_price;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[245].run(205);
		}
	}
};

// Block 884 (Conditionprice corss down from tp)
class Block206: public MDL_Condition<MDLIC_prices_prices,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block206() {
		__block_number = 206;
		__block_user_number = "884";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {245};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Symbol = CurrentSymbol();

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::tp2_price;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[245].run(206);
		}
	}
};

// Block 885 (For each Position)
class Block207: public MDL_LoopStartTrades<string,string,string,string,string,string,int,int,int,int>
{

	public: /* Constructor */
	Block207() {
		__block_number = 207;
		__block_user_number = "885";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {209,210};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[209].run(207);
		}
		else if (value == 1) {
			_blocks_[210].run(207);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
	}
};

// Block 947 (Alert message)
class Block208: public MDL_AlertMessageAdvanced<string,string,MDLIC_text_text,string,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,bool>
{

	public: /* Constructor */
	Block208() {
		__block_number = 208;
		__block_user_number = "947";
		_beforeExecuteEnabled = true;

		// IC input parameters
		AlertValue1.Text = "Take profit level 2 hit";
		AlertValue2.Value = 0.0;
		AlertValue3.Value = 0.0;
		AlertValue4.Value = 0.0;
		AlertValue5.Value = 0.0;
		AlertValue6.Value = 0.0;
		AlertValue7.Value = 0.0;
		AlertValue8.Value = 0.0;
		AlertValue9.Value = 0.0;
		AlertValue10.Value = 0.0;
		// Block input parameters
		AlertTitle = "Take profit hit";
		AlertLabel1 = "Detail :";
	}

	public: /* Custom methods */
	virtual string _AlertValue1_() {return AlertValue1._execute_();}
	virtual double _AlertValue2_() {return AlertValue2._execute_();}
	virtual double _AlertValue3_() {return AlertValue3._execute_();}
	virtual double _AlertValue4_() {return AlertValue4._execute_();}
	virtual double _AlertValue5_() {return AlertValue5._execute_();}
	virtual double _AlertValue6_() {return AlertValue6._execute_();}
	virtual double _AlertValue7_() {return AlertValue7._execute_();}
	virtual double _AlertValue8_() {return AlertValue8._execute_();}
	virtual double _AlertValue9_() {return AlertValue9._execute_();}
	virtual double _AlertValue10_() {return AlertValue10._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		AlsoSendNotification = (bool)c::Send_Phone_Notification;
	}
};

// Block 948 (Delete BE target line)
class Block209: public MDL_ChartDeleteObjects<string,string,color,string,int,int>
{

	public: /* Constructor */
	Block209() {
		__block_number = 209;
		__block_user_number = "948";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {208};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		NameContains = "lineTP2";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[208].run(209);
		}
	}

	virtual void _beforeExecute_()
	{

		ObjColor = (color)EMPTY_VALUE;
	}
};

// Block 949 (close (partially))
class Block210: public MDL_LoopClosePart<string,double,double,ulong,color>
{

	public: /* Constructor */
	Block210() {
		__block_number = 210;
		__block_user_number = "949";
		_beforeExecuteEnabled = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		PartVolPercent = (double)c::TP2_Percent;
		ArrowColor = (color)clrDeepPink;
	}
};

// Block 950 (Check Flag (textual)order type is buy)
class Block211: public MDL_FlagCheckT<string,string>
{

	public: /* Constructor */
	Block211() {
		__block_number = 211;
		__block_user_number = "950";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {212,213};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		FlagName = "tp_order_type";
		FlagValue = "buy";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[213].run(211);
		}
		else if (value == 1) {
			_blocks_[212].run(211);
		}
	}
};

// Block 951 (Conditionprice corss up from tp)
class Block212: public MDL_Condition<MDLIC_prices_prices,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block212() {
		__block_number = 212;
		__block_user_number = "951";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {246};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Lo.Price = "BID";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Symbol = CurrentSymbol();

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::tp3_price;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[246].run(212);
		}
	}
};

// Block 952 (Conditionprice corss down from tp)
class Block213: public MDL_Condition<MDLIC_prices_prices,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block213() {
		__block_number = 213;
		__block_user_number = "952";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {246};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Symbol = CurrentSymbol();

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::tp3_price;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[246].run(213);
		}
	}
};

// Block 953 (For each Position)
class Block214: public MDL_LoopStartTrades<string,string,string,string,string,string,int,int,int,int>
{

	public: /* Constructor */
	Block214() {
		__block_number = 214;
		__block_user_number = "953";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {216,217};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[216].run(214);
		}
		else if (value == 1) {
			_blocks_[217].run(214);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
	}
};

// Block 1015 (Alert message)
class Block215: public MDL_AlertMessageAdvanced<string,string,MDLIC_text_text,string,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,bool>
{

	public: /* Constructor */
	Block215() {
		__block_number = 215;
		__block_user_number = "1015";
		_beforeExecuteEnabled = true;

		// IC input parameters
		AlertValue1.Text = "Take profit level 3 hit";
		AlertValue2.Value = 0.0;
		AlertValue3.Value = 0.0;
		AlertValue4.Value = 0.0;
		AlertValue5.Value = 0.0;
		AlertValue6.Value = 0.0;
		AlertValue7.Value = 0.0;
		AlertValue8.Value = 0.0;
		AlertValue9.Value = 0.0;
		AlertValue10.Value = 0.0;
		// Block input parameters
		AlertTitle = "Take profit hit";
		AlertLabel1 = "Detail :";
	}

	public: /* Custom methods */
	virtual string _AlertValue1_() {return AlertValue1._execute_();}
	virtual double _AlertValue2_() {return AlertValue2._execute_();}
	virtual double _AlertValue3_() {return AlertValue3._execute_();}
	virtual double _AlertValue4_() {return AlertValue4._execute_();}
	virtual double _AlertValue5_() {return AlertValue5._execute_();}
	virtual double _AlertValue6_() {return AlertValue6._execute_();}
	virtual double _AlertValue7_() {return AlertValue7._execute_();}
	virtual double _AlertValue8_() {return AlertValue8._execute_();}
	virtual double _AlertValue9_() {return AlertValue9._execute_();}
	virtual double _AlertValue10_() {return AlertValue10._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		AlsoSendNotification = (bool)c::Send_Phone_Notification;
	}
};

// Block 1016 (Delete BE target line)
class Block216: public MDL_ChartDeleteObjects<string,string,color,string,int,int>
{

	public: /* Constructor */
	Block216() {
		__block_number = 216;
		__block_user_number = "1016";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {215};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		NameContains = "lineTP3";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[215].run(216);
		}
	}

	virtual void _beforeExecute_()
	{

		ObjColor = (color)EMPTY_VALUE;
	}
};

// Block 1017 (close (partially))
class Block217: public MDL_LoopClosePart<string,double,double,ulong,color>
{

	public: /* Constructor */
	Block217() {
		__block_number = 217;
		__block_user_number = "1017";
		_beforeExecuteEnabled = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		PartVolPercent = (double)c::TP3_Percent;
		ArrowColor = (color)clrDeepPink;
	}
};

// Block 1018 (Check Flag (textual)order type is buy)
class Block218: public MDL_FlagCheckT<string,string>
{

	public: /* Constructor */
	Block218() {
		__block_number = 218;
		__block_user_number = "1018";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {219,220};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		FlagName = "tp_order_type";
		FlagValue = "buy";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[220].run(218);
		}
		else if (value == 1) {
			_blocks_[219].run(218);
		}
	}
};

// Block 1019 (Conditionprice corss up from tp)
class Block219: public MDL_Condition<MDLIC_prices_prices,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block219() {
		__block_number = 219;
		__block_user_number = "1019";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {247};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Lo.Price = "BID";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Symbol = CurrentSymbol();

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::tp4_price;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[247].run(219);
		}
	}
};

// Block 1020 (Conditionprice corss down from tp)
class Block220: public MDL_Condition<MDLIC_prices_prices,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block220() {
		__block_number = 220;
		__block_user_number = "1020";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {247};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Symbol = CurrentSymbol();

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::tp4_price;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[247].run(220);
		}
	}
};

// Block 1021 (For each Position)
class Block221: public MDL_LoopStartTrades<string,string,string,string,string,string,int,int,int,int>
{

	public: /* Constructor */
	Block221() {
		__block_number = 221;
		__block_user_number = "1021";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {223,224};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[223].run(221);
		}
		else if (value == 1) {
			_blocks_[224].run(221);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
	}
};

// Block 1083 (Alert message)
class Block222: public MDL_AlertMessageAdvanced<string,string,MDLIC_text_text,string,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,bool>
{

	public: /* Constructor */
	Block222() {
		__block_number = 222;
		__block_user_number = "1083";
		_beforeExecuteEnabled = true;

		// IC input parameters
		AlertValue1.Text = "Take profit level 4 hit";
		AlertValue2.Value = 0.0;
		AlertValue3.Value = 0.0;
		AlertValue4.Value = 0.0;
		AlertValue5.Value = 0.0;
		AlertValue6.Value = 0.0;
		AlertValue7.Value = 0.0;
		AlertValue8.Value = 0.0;
		AlertValue9.Value = 0.0;
		AlertValue10.Value = 0.0;
		// Block input parameters
		AlertTitle = "Take profit hit";
		AlertLabel1 = "Detail :";
	}

	public: /* Custom methods */
	virtual string _AlertValue1_() {return AlertValue1._execute_();}
	virtual double _AlertValue2_() {return AlertValue2._execute_();}
	virtual double _AlertValue3_() {return AlertValue3._execute_();}
	virtual double _AlertValue4_() {return AlertValue4._execute_();}
	virtual double _AlertValue5_() {return AlertValue5._execute_();}
	virtual double _AlertValue6_() {return AlertValue6._execute_();}
	virtual double _AlertValue7_() {return AlertValue7._execute_();}
	virtual double _AlertValue8_() {return AlertValue8._execute_();}
	virtual double _AlertValue9_() {return AlertValue9._execute_();}
	virtual double _AlertValue10_() {return AlertValue10._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		AlsoSendNotification = (bool)c::Send_Phone_Notification;
	}
};

// Block 1084 (Delete BE target line)
class Block223: public MDL_ChartDeleteObjects<string,string,color,string,int,int>
{

	public: /* Constructor */
	Block223() {
		__block_number = 223;
		__block_user_number = "1084";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {222};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		NameContains = "lineTP4";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[222].run(223);
		}
	}

	virtual void _beforeExecute_()
	{

		ObjColor = (color)EMPTY_VALUE;
	}
};

// Block 1085 (close (partially))
class Block224: public MDL_LoopClosePart<string,double,double,ulong,color>
{

	public: /* Constructor */
	Block224() {
		__block_number = 224;
		__block_user_number = "1085";
		_beforeExecuteEnabled = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		PartVolPercent = (double)c::TP4_Percent;
		ArrowColor = (color)clrDeepPink;
	}
};

// Block 1086 (Check Flag (textual)order type is buy)
class Block225: public MDL_FlagCheckT<string,string>
{

	public: /* Constructor */
	Block225() {
		__block_number = 225;
		__block_user_number = "1086";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {226,227};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		FlagName = "tp_order_type";
		FlagValue = "buy";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[227].run(225);
		}
		else if (value == 1) {
			_blocks_[226].run(225);
		}
	}
};

// Block 1087 (Conditionprice corss up from tp)
class Block226: public MDL_Condition<MDLIC_prices_prices,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block226() {
		__block_number = 226;
		__block_user_number = "1087";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {248};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Lo.Price = "BID";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Symbol = CurrentSymbol();

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::tp5_price;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[248].run(226);
		}
	}
};

// Block 1088 (Conditionprice corss down from tp)
class Block227: public MDL_Condition<MDLIC_prices_prices,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block227() {
		__block_number = 227;
		__block_user_number = "1088";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {248};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Symbol = CurrentSymbol();

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::tp5_price;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[248].run(227);
		}
	}
};

// Block 1089 (For each Position)
class Block228: public MDL_LoopStartTrades<string,string,string,string,string,string,int,int,int,int>
{

	public: /* Constructor */
	Block228() {
		__block_number = 228;
		__block_user_number = "1089";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {230,231};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[230].run(228);
		}
		else if (value == 1) {
			_blocks_[231].run(228);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
	}
};

// Block 1151 (Alert message)
class Block229: public MDL_AlertMessageAdvanced<string,string,MDLIC_text_text,string,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,string,MDLIC_value_value,double,bool>
{

	public: /* Constructor */
	Block229() {
		__block_number = 229;
		__block_user_number = "1151";
		_beforeExecuteEnabled = true;

		// IC input parameters
		AlertValue1.Text = "Take profit level 5 hit";
		AlertValue2.Value = 0.0;
		AlertValue3.Value = 0.0;
		AlertValue4.Value = 0.0;
		AlertValue5.Value = 0.0;
		AlertValue6.Value = 0.0;
		AlertValue7.Value = 0.0;
		AlertValue8.Value = 0.0;
		AlertValue9.Value = 0.0;
		AlertValue10.Value = 0.0;
		// Block input parameters
		AlertTitle = "Take profit hit";
		AlertLabel1 = "Detail :";
	}

	public: /* Custom methods */
	virtual string _AlertValue1_() {return AlertValue1._execute_();}
	virtual double _AlertValue2_() {return AlertValue2._execute_();}
	virtual double _AlertValue3_() {return AlertValue3._execute_();}
	virtual double _AlertValue4_() {return AlertValue4._execute_();}
	virtual double _AlertValue5_() {return AlertValue5._execute_();}
	virtual double _AlertValue6_() {return AlertValue6._execute_();}
	virtual double _AlertValue7_() {return AlertValue7._execute_();}
	virtual double _AlertValue8_() {return AlertValue8._execute_();}
	virtual double _AlertValue9_() {return AlertValue9._execute_();}
	virtual double _AlertValue10_() {return AlertValue10._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		AlsoSendNotification = (bool)c::Send_Phone_Notification;
	}
};

// Block 1152 (Delete BE target line)
class Block230: public MDL_ChartDeleteObjects<string,string,color,string,int,int>
{

	public: /* Constructor */
	Block230() {
		__block_number = 230;
		__block_user_number = "1152";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {229};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		NameContains = "lineTP5";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[229].run(230);
		}
	}

	virtual void _beforeExecute_()
	{

		ObjColor = (color)EMPTY_VALUE;
	}
};

// Block 1153 (close (partially))
class Block231: public MDL_LoopClosePart<string,double,double,ulong,color>
{

	public: /* Constructor */
	Block231() {
		__block_number = 231;
		__block_user_number = "1153";
		_beforeExecuteEnabled = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		PartVolPercent = (double)c::TP5_Percent;
		ArrowColor = (color)clrDeepPink;
	}
};

// Block 1154 (ConditionTP2 percent != 0)
class Block232: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block232() {
		__block_number = 232;
		__block_user_number = "1154";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {241};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 0.0;
		// Block input parameters
		compare = "!=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = c::TP2_Percent;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[241].run(232);
		}
	}
};

// Block 1155 (ConditionTP3 percent != 0)
class Block233: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block233() {
		__block_number = 233;
		__block_user_number = "1155";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {242};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 0.0;
		// Block input parameters
		compare = "!=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = c::TP3_Percent;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[242].run(233);
		}
	}
};

// Block 1156 (ConditionTP4 percent != 0)
class Block234: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block234() {
		__block_number = 234;
		__block_user_number = "1156";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {243};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 0.0;
		// Block input parameters
		compare = "!=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = c::TP4_Percent;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[243].run(234);
		}
	}
};

// Block 1157 (ConditionTP5 percent != 0)
class Block235: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block235() {
		__block_number = 235;
		__block_user_number = "1157";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {244};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 0.0;
		// Block input parameters
		compare = "!=";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = c::TP5_Percent;

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[244].run(235);
		}
	}
};

// Block 1158 (Position closed)
class Block236: public MDL_eTrade_TradeClosed<string,string,string,string,string,string,int>
{

	public: /* Constructor */
	Block236() {
		__block_number = 236;
		__block_user_number = "1158";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {237};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		GroupMode = "all";
		ClosePartialMode = 1;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[237].run(236);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
	}
};

// Block 1159 (No position)
class Block237: public MDL_NoOpenedOrders<string,string,string,string,string>
{

	public: /* Constructor */
	Block237() {
		__block_number = 237;
		__block_user_number = "1159";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {238,303};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[238].run(237);
			_blocks_[303].run(237);
		}
	}

	virtual void _beforeExecute_()
	{

		Symbol = (string)CurrentSymbol();
	}
};

// Block 1160 (Delete tp target lines)
class Block238: public MDL_ChartDeleteObjects<string,string,color,string,int,int>
{

	public: /* Constructor */
	Block238() {
		__block_number = 238;
		__block_user_number = "1160";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {254};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		NameContains = "lineTP";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[254].run(238);
		}
	}

	virtual void _beforeExecute_()
	{
		// Set variables (in)
		v::partial_tp_is_open = (bool)(false);

		ObjColor = (color)EMPTY_VALUE;
	}
};

// Block 1161 (Check Flag (true-false)tp1_hit == false)
class Block239: public MDL_FlagCheckB<string,bool>
{

	public: /* Constructor */
	Block239() {
		__block_number = 239;
		__block_user_number = "1161";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {197};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		FlagName = "TP1_hit";
		FlagValue = false;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[197].run(239);
		}
	}
};

// Block 1162 (Set Flag (true-false)tp1_hit = true)
class Block240: public MDL_FlagSetB<string,bool>
{

	public: /* Constructor */
	Block240() {
		__block_number = 240;
		__block_user_number = "1162";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {200};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		FlagName = "TP1_hit";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[200].run(240);
		}
	}
};

// Block 1163 (Check Flag (true-false)tp1_hit == false)
class Block241: public MDL_FlagCheckB<string,bool>
{

	public: /* Constructor */
	Block241() {
		__block_number = 241;
		__block_user_number = "1163";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {204};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		FlagName = "TP2_hit";
		FlagValue = false;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[204].run(241);
		}
	}
};

// Block 1164 (Check Flag (true-false)tp1_hit == false)
class Block242: public MDL_FlagCheckB<string,bool>
{

	public: /* Constructor */
	Block242() {
		__block_number = 242;
		__block_user_number = "1164";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {211};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		FlagName = "TP3_hit";
		FlagValue = false;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[211].run(242);
		}
	}
};

// Block 1165 (Check Flag (true-false)tp1_hit == false)
class Block243: public MDL_FlagCheckB<string,bool>
{

	public: /* Constructor */
	Block243() {
		__block_number = 243;
		__block_user_number = "1165";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {218};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		FlagName = "TP4_hit";
		FlagValue = false;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[218].run(243);
		}
	}
};

// Block 1166 (Check Flag (true-false)tp1_hit == false)
class Block244: public MDL_FlagCheckB<string,bool>
{

	public: /* Constructor */
	Block244() {
		__block_number = 244;
		__block_user_number = "1166";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {225};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		FlagName = "TP5_hit";
		FlagValue = false;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[225].run(244);
		}
	}
};

// Block 1167 (Set Flag (true-false)tp_hit = true)
class Block245: public MDL_FlagSetB<string,bool>
{

	public: /* Constructor */
	Block245() {
		__block_number = 245;
		__block_user_number = "1167";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {207};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		FlagName = "TP2_hit";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[207].run(245);
		}
	}
};

// Block 1168 (Set Flag (true-false)tp_hit = true)
class Block246: public MDL_FlagSetB<string,bool>
{

	public: /* Constructor */
	Block246() {
		__block_number = 246;
		__block_user_number = "1168";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {214};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		FlagName = "TP3_hit";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[214].run(246);
		}
	}
};

// Block 1169 (Set Flag (true-false)tp_hit = true)
class Block247: public MDL_FlagSetB<string,bool>
{

	public: /* Constructor */
	Block247() {
		__block_number = 247;
		__block_user_number = "1169";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {221};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		FlagName = "TP4_hit";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[221].run(247);
		}
	}
};

// Block 1170 (Set Flag (true-false)tp_hit = true)
class Block248: public MDL_FlagSetB<string,bool>
{

	public: /* Constructor */
	Block248() {
		__block_number = 248;
		__block_user_number = "1170";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {228};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		FlagName = "TP5_hit";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[228].run(248);
		}
	}
};

// Block 1171 (Set Flag (true-false)tp1_hit = false)
class Block249: public MDL_FlagSetB<string,bool>
{

	public: /* Constructor */
	Block249() {
		__block_number = 249;
		__block_user_number = "1171";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {250};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		FlagName = "TP1_hit";
		FlagValue = false;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[250].run(249);
		}
	}
};

// Block 1172 (Set Flag (true-false)tp1_hit = false)
class Block250: public MDL_FlagSetB<string,bool>
{

	public: /* Constructor */
	Block250() {
		__block_number = 250;
		__block_user_number = "1172";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {251};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		FlagName = "TP2_hit";
		FlagValue = false;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[251].run(250);
		}
	}
};

// Block 1173 (Set Flag (true-false)tp1_hit = false)
class Block251: public MDL_FlagSetB<string,bool>
{

	public: /* Constructor */
	Block251() {
		__block_number = 251;
		__block_user_number = "1173";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {252};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		FlagName = "TP3_hit";
		FlagValue = false;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[252].run(251);
		}
	}
};

// Block 1174 (Set Flag (true-false)tp1_hit = false)
class Block252: public MDL_FlagSetB<string,bool>
{

	public: /* Constructor */
	Block252() {
		__block_number = 252;
		__block_user_number = "1174";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {253};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		FlagName = "TP4_hit";
		FlagValue = false;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[253].run(252);
		}
	}
};

// Block 1175 (Set Flag (true-false)tp1_hit = false)
class Block253: public MDL_FlagSetB<string,bool>
{

	public: /* Constructor */
	Block253() {
		__block_number = 253;
		__block_user_number = "1175";

		// Block input parameters
		FlagName = "TP5_hit";
		FlagValue = false;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}
};

// Block 1176 (Set Flag (true-false)shouldTakeProfit)
class Block254: public MDL_FlagSetB<string,bool>
{

	public: /* Constructor */
	Block254() {
		__block_number = 254;
		__block_user_number = "1176";

		// Block input parameters
		FlagName = "shouldTakeProfit";
		FlagValue = false;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}
};

// Block 1178 (Conditioncal_is_open == false)
class Block255: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_boolean_boolean,bool,int>
{

	public: /* Constructor */
	Block255() {
		__block_number = 255;
		__block_user_number = "1178";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {24};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Boolean = false;
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual bool _Lo_() {
		Lo.Boolean = v::cal_is_open;

		return Lo._execute_();
	}
	virtual bool _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[24].run(255);
		}
	}
};

// Block 1179 (Formulapending distance pip)
class Block256: public MDL_Formula_13<MDLIC_prices_prices,double,string,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block256() {
		__block_number = 256;
		__block_user_number = "1179";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {259};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Lo.Price = "MID";
		// Block input parameters
		compare = "-";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Symbol = CurrentSymbol();

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Value = v::pending_order_price;

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[259].run(256);
		}
	}
};

// Block 1198 (Conditionpending&nbsp; line is blow price)
class Block257: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_prices_prices,double,int>
{

	public: /* Constructor */
	Block257() {
		__block_number = 257;
		__block_user_number = "1198";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {256,258};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Price = "MID";
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::pending_order_price;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Symbol = CurrentSymbol();

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[258].run(257);
		}
		else if (value == 1) {
			_blocks_[256].run(257);
		}
	}
};

// Block 1199 (Formulapending distance pip)
class Block258: public MDL_Formula_14<MDLIC_value_value,double,string,MDLIC_prices_prices,double>
{

	public: /* Constructor */
	Block258() {
		__block_number = 258;
		__block_user_number = "1199";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {259};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Price = "MID";
		// Block input parameters
		compare = "-";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Value = v::pending_order_price;

		return Lo._execute_();
	}
	virtual double _Ro_() {
		Ro.Symbol = CurrentSymbol();

		return Ro._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[259].run(258);
		}
	}
};

// Block 1200 (Modify Variables)
class Block259: public MDL_ModifyVariables<int,MDLIC_text_text,string,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block259() {
		__block_number = 259;
		__block_user_number = "1200";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {13};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual string _Value1_() {
		Value1.Text = "Distance : " + (MathAbs(NormalizeDouble ( (v::pending_distance_pip  * v::pip_multiper /10) , 1 ))) +  " pip";

		return Value1._execute_();
	}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[13].run(259);
		}
	}

	virtual void _beforeExecute_()
	{

		v::pending_label_text = _Value1_();
	}
};

// Block 1204 (Conditionpair is us30)
class Block260: public MDL_Condition<MDLIC_market_Currency,string,string,MDLIC_text_text,string,int>
{

	public: /* Constructor */
	Block260() {
		__block_number = 260;
		__block_user_number = "1204";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {261,262};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Text = "US3";
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual string _Lo_() {return Lo._execute_();}
	virtual string _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[262].run(260);
		}
		else if (value == 1) {
			_blocks_[261].run(260);
		}
	}
};

// Block 1205 (Modify Variablesit is us30)
class Block261: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block261() {
		__block_number = 261;
		__block_user_number = "1205";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {273};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Value1.Value = 0.1;
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[273].run(261);
		}
	}

	virtual void _beforeExecute_()
	{

		v::risk_percent_factor = _Value1_();
	}
};

// Block 1207 (Conditionpair is ndx100)
class Block262: public MDL_Condition<MDLIC_market_Currency,string,string,MDLIC_text_text,string,int>
{

	public: /* Constructor */
	Block262() {
		__block_number = 262;
		__block_user_number = "1207";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {261,274};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Text = "NDX";
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual string _Lo_() {return Lo._execute_();}
	virtual string _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[274].run(262);
		}
		else if (value == 1) {
			_blocks_[261].run(262);
		}
	}
};

// Block 1210 (Conditiondigits = 1)
class Block263: public MDL_Condition<MDLIC_market_digits,int,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block263() {
		__block_number = 263;
		__block_user_number = "1210";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {264};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual int _Lo_() {
		Lo.Symbol = CurrentSymbol();

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[264].run(263);
		}
		else if (value == 1) {
			v::pip_multiper = (int)(10);
		}
	}
};

// Block 1211 (Conditiondigits = 2)
class Block264: public MDL_Condition<MDLIC_market_digits,int,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block264() {
		__block_number = 264;
		__block_user_number = "1211";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {265};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 2.0;
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual int _Lo_() {
		Lo.Symbol = CurrentSymbol();

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[265].run(264);
		}
		else if (value == 1) {
			v::pip_multiper = (int)(100);
		}
	}
};

// Block 1212 (Conditiondigits = 3)
class Block265: public MDL_Condition<MDLIC_market_digits,int,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block265() {
		__block_number = 265;
		__block_user_number = "1212";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {266};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 3.0;
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual int _Lo_() {
		Lo.Symbol = CurrentSymbol();

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[266].run(265);
		}
		else if (value == 1) {
			v::pip_multiper = (int)(1000);
		}
	}
};

// Block 1213 (Conditiondigits = 4&nbsp;)
class Block266: public MDL_Condition<MDLIC_market_digits,int,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block266() {
		__block_number = 266;
		__block_user_number = "1213";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {267};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 4.0;
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual int _Lo_() {
		Lo.Symbol = CurrentSymbol();

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[267].run(266);
		}
		else if (value == 1) {
			v::pip_multiper = (int)(10000);
		}
	}
};

// Block 1214 (Conditiondigits = 5)
class Block267: public MDL_Condition<MDLIC_market_digits,int,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block267() {
		__block_number = 267;
		__block_user_number = "1214";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {268};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Ro.Value = 5.0;
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual int _Lo_() {
		Lo.Symbol = CurrentSymbol();

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[268].run(267);
		}
		else if (value == 1) {
			v::pip_multiper = (int)(100000);
		}
	}
};

// Block 1215 (Conditiondigits = 6)
class Block268: public MDL_Condition<MDLIC_market_digits,int,string,MDLIC_value_value,double,int>
{

	public: /* Constructor */
	Block268() {
		__block_number = 268;
		__block_user_number = "1215";


		// IC input parameters
		Ro.Value = 6.0;
		// Block input parameters
		compare = "==";
	}

	public: /* Custom methods */
	virtual int _Lo_() {
		Lo.Symbol = CurrentSymbol();

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			v::pip_multiper = (int)(1000000);
		}
	}
};

// Block 1217 (Custom MQL code)
class Block269: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block269() {
		__block_number = 269;
		__block_user_number = "1217";
		_beforeExecuteEnabled = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		ObjectSetInteger(ChartID(),"lineBEtarget",OBJPROP_PRICE_SCALE,true);
	}
};

// Block 1218 (Custom MQL code)
class Block270: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block270() {
		__block_number = 270;
		__block_user_number = "1218";
		_beforeExecuteEnabled = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		ObjectSetInteger(ChartID(),"lineBEtriger",OBJPROP_PRICE_SCALE,true);
	}
};

// Block 1219 (Custom MQL code)
class Block271: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block271() {
		__block_number = 271;
		__block_user_number = "1219";
		_beforeExecuteEnabled = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		ObjectSetInteger(ChartID(),"linePendingOrder",OBJPROP_PRICE_SCALE,true);
	}
};

// Block 1220 (Modify Variables)
class Block272: public MDL_ModifyVariables<int,MDLIC_objectattributes_string,string,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block272() {
		__block_number = 272;
		__block_user_number = "1220";
		_beforeExecuteEnabled = true;

		// IC input parameters
		Value1.Name = "txtRiskPercent";
	}

	public: /* Custom methods */
	virtual string _Value1_() {
		Value1.Property = OBJPROP_TEXT;

		return Value1._execute_();
	}
	virtual double _Value2_() {
		Value2.Value = v::risk_percent;

		double value = (double)Value2._execute_();
		value = value*v::risk_percent_factor; // Adjust the value
		return value;
	}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		v::correct_risk_percent = _Value2_();
	}
};

// Block 1221 (Modify Variablesset risk_percent)
class Block273: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block273() {
		__block_number = 273;
		__block_user_number = "1221";
		_beforeExecuteEnabled = true;
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.Value = c::Risk_Percent;

		return Value1._execute_();
	}
	virtual double _Value2_() {
		Value2.Value = v::risk_percent;

		double value = (double)Value2._execute_();
		value = value*v::risk_percent_factor; // Adjust the value
		return value;
	}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		v::risk_percent = _Value1_();
		v::correct_risk_percent = _Value2_();
	}
};

// Block 1222 (Modify Variablesit is other pairs)
class Block274: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block274() {
		__block_number = 274;
		__block_user_number = "1222";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {275};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Custom methods */
	virtual double _Value1_() {return Value1._execute_();}
	virtual double _Value2_() {return Value2._execute_();}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[275].run(274);
		}
	}

	virtual void _beforeExecute_()
	{

		v::risk_percent_factor = _Value1_();
	}
};

// Block 1238 (Modify Variablesset risk_percent)
class Block275: public MDL_ModifyVariables<int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>
{

	public: /* Constructor */
	Block275() {
		__block_number = 275;
		__block_user_number = "1238";
		_beforeExecuteEnabled = true;
	}

	public: /* Custom methods */
	virtual double _Value1_() {
		Value1.Value = c::Risk_Percent;

		return Value1._execute_();
	}
	virtual double _Value2_() {
		Value2.Value = v::risk_percent;

		double value = (double)Value2._execute_();
		value = value*v::risk_percent_factor; // Adjust the value
		return value;
	}
	virtual double _Value3_() {return Value3._execute_();}
	virtual double _Value4_() {return Value4._execute_();}
	virtual double _Value5_() {return Value5._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		v::risk_percent = _Value1_();
		v::correct_risk_percent = _Value2_();
	}
};

// Block 1240 (btnMinimize)
class Block276: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block276() {
		__block_number = 276;
		__block_user_number = "1240";
		_beforeExecuteEnabled = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		string name = "btnMinimize";

string text =  "-" ; 
int x = 320;
int y =  48;
int width =  30;
int height =  30;
color bgColor =  (color)0x7D756C;
color textColor = clrWhite;
int fontSize = 18;
ObjectCreate(0, name, OBJ_BUTTON, 0, 0, 0);
ObjectSetString(0, name, OBJPROP_TEXT, text);
ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
ObjectSetInteger(0, name, OBJPROP_XSIZE, width);
ObjectSetInteger(0, name, OBJPROP_YSIZE, height);
ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
ObjectSetInteger(0, name, OBJPROP_ANCHOR, ANCHOR_LEFT_UPPER);
ObjectSetInteger(0, name, OBJPROP_FONTSIZE, fontSize);
ObjectSetInteger(0, name, OBJPROP_COLOR, textColor);
ObjectSetInteger(0, name, OBJPROP_BGCOLOR, bgColor);
ObjectSetInteger(0, name, OBJPROP_BORDER_COLOR, bgColor);
ObjectSetInteger(0, name, OBJPROP_BACK, false);
ObjectSetInteger(0, name, OBJPROP_STATE, false);
ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
ObjectSetInteger(0, name, OBJPROP_SELECTED, false);
ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
ObjectSetInteger(0, name, OBJPROP_ZORDER, 10);
	}
};

// Block 1241 (Mouse clicked on objectbtnMinimize)
class Block277: public MDL_eChart_MouseClickObject<string,string>
{

	public: /* Constructor */
	Block277() {
		__block_number = 277;
		__block_user_number = "1241";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {278};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		NameFilterMode = "name";
		ObjName = "btnMinimize";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[278].run(277);
		}
	}
};

// Block 1242 (Check Flag (true-false)minimized)
class Block278: public MDL_FlagCheckB<string,bool>
{

	public: /* Constructor */
	Block278() {
		__block_number = 278;
		__block_user_number = "1242";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {279,280};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		FlagName = "minimized";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[280].run(278);
		}
		else if (value == 1) {
			_blocks_[279].run(278);
		}
	}
};

// Block 1243 (Set Flag (true-false))
class Block279: public MDL_FlagSetB<string,bool>
{

	public: /* Constructor */
	Block279() {
		__block_number = 279;
		__block_user_number = "1243";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {282,299};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		FlagName = "minimized";
		FlagValue = false;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[282].run(279);
			_blocks_[299].run(279);
		}
	}
};

// Block 1244 (Set Flag (true-false))
class Block280: public MDL_FlagSetB<string,bool>
{

	public: /* Constructor */
	Block280() {
		__block_number = 280;
		__block_user_number = "1244";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {281};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		FlagName = "minimized";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[281].run(280);
		}
	}
};

// Block 1245 (Custom MQL code)
class Block281: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block281() {
		__block_number = 281;
		__block_user_number = "1245";
		_beforeExecuteEnabled = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		ObjectDelete(0, "btnOpenCalc");
ObjectDelete(0, "btnPendingOrder");
ObjectDelete(0, "btnOpenTrade");
ObjectDelete(0, "btnCloseFull");
ObjectDelete(0, "btnCloseFiftyPercent");
ObjectDelete(0, "btnCloseCustom");
ObjectDelete(0, "btnAutoBreakEvenSet");
ObjectDelete(0, "btnAutoBreakEven");
ObjectDelete(0, "btnAddPartialTakeProfit");
ObjectDelete(0, "btnAddPartialTakeProfitSet");

ObjectDelete(0, "txtPositionComment");
ObjectDelete(0, "txtRiskPercent");
ObjectDelete(0, "btnRiskPlus");
ObjectDelete(0, "lblPercent");
ObjectDelete(0, "btnRiskMinus");
ObjectDelete(0, "btnRiskFree");
ObjectDelete(0, "lblNote");

int x1 = 20;
int y1 = 30;
int x2 = 370;
int y2 = 95;
int borderWidth = 2; // Width of the border in pixels

ObjectSetInteger(0, "ButtonBorder", OBJPROP_XSIZE, (x2 - x1) + (2 * borderWidth));
ObjectSetInteger(0, "ButtonBorder", OBJPROP_YSIZE, (y2 - y1) + (2 * borderWidth));
ObjectSetInteger(0, "ButtonBackground", OBJPROP_XSIZE, (x2 - x1) + (2 * borderWidth));
ObjectSetInteger(0, "ButtonBackground", OBJPROP_YSIZE, (y2 - y1) + (2 * borderWidth));
	}
};

// Block 1246 (btnOpenCalc)
class Block282: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block282() {
		__block_number = 282;
		__block_user_number = "1246";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {283,298};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[283].run(282);
			_blocks_[298].run(282);
		}
	}

	virtual void _beforeExecute_()
	{

		string name = "btnOpenCalc";

string text =  "Open Calc" ; 
int x = 41;
int y =  95;
int width =  141;
int height =  39;
color bgColor =  (color)0x548718;
color textColor = clrWhite;
int fontSize = 12;
ObjectCreate(0, name, OBJ_BUTTON, 0, 0, 0);
ObjectSetString(0, name, OBJPROP_TEXT, text);
ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
ObjectSetInteger(0, name, OBJPROP_XSIZE, width);
ObjectSetInteger(0, name, OBJPROP_YSIZE, height);
ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
ObjectSetInteger(0, name, OBJPROP_ANCHOR, ANCHOR_LEFT_UPPER);
ObjectSetInteger(0, name, OBJPROP_FONTSIZE, fontSize);
ObjectSetInteger(0, name, OBJPROP_COLOR, textColor);
ObjectSetInteger(0, name, OBJPROP_BGCOLOR, bgColor);
ObjectSetInteger(0, name, OBJPROP_BORDER_COLOR, bgColor);
ObjectSetInteger(0, name, OBJPROP_BACK, false);
ObjectSetInteger(0, name, OBJPROP_STATE, false);
ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
ObjectSetInteger(0, name, OBJPROP_SELECTED, false);
ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
ObjectSetInteger(0, name, OBJPROP_ZORDER, 10);
	}
};

// Block 1247 (btnPendingOrder)
class Block283: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block283() {
		__block_number = 283;
		__block_user_number = "1247";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {284};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[284].run(283);
		}
	}

	virtual void _beforeExecute_()
	{

		string name = "btnPendingOrder";

string text =  "Pending Order" ; 
int x = 207;
int y =  95;
int width =  141;
int height =  39;
color bgColor =  (color)0x548718;
color textColor = clrWhite;
int fontSize = 12;
ObjectCreate(0, name, OBJ_BUTTON, 0, 0, 0);
ObjectSetString(0, name, OBJPROP_TEXT, text);
ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
ObjectSetInteger(0, name, OBJPROP_XSIZE, width);
ObjectSetInteger(0, name, OBJPROP_YSIZE, height);
ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
ObjectSetInteger(0, name, OBJPROP_ANCHOR, ANCHOR_LEFT_UPPER);
ObjectSetInteger(0, name, OBJPROP_FONTSIZE, fontSize);
ObjectSetInteger(0, name, OBJPROP_COLOR, textColor);
ObjectSetInteger(0, name, OBJPROP_BGCOLOR, bgColor);
ObjectSetInteger(0, name, OBJPROP_BORDER_COLOR, bgColor);
ObjectSetInteger(0, name, OBJPROP_BACK, false);
ObjectSetInteger(0, name, OBJPROP_STATE, false);
ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
ObjectSetInteger(0, name, OBJPROP_SELECTED, false);
ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
ObjectSetInteger(0, name, OBJPROP_ZORDER, 10);
	}
};

// Block 1248 (btnOpenPosition)
class Block284: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block284() {
		__block_number = 284;
		__block_user_number = "1248";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {285};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[285].run(284);
		}
	}

	virtual void _beforeExecute_()
	{

		string name = "btnOpenTrade";

string text =  "Open Position" ; 
int x = 41;
int y =  141;
int width =  141;
int height =  39;
color bgColor =  (color)0x4635DC;
color textColor = clrWhite;
int fontSize = 12;
ObjectCreate(0, name, OBJ_BUTTON, 0, 0, 0);
ObjectSetString(0, name, OBJPROP_TEXT, text);
ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
ObjectSetInteger(0, name, OBJPROP_XSIZE, width);
ObjectSetInteger(0, name, OBJPROP_YSIZE, height);
ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
ObjectSetInteger(0, name, OBJPROP_ANCHOR, ANCHOR_LEFT_UPPER);
ObjectSetInteger(0, name, OBJPROP_FONTSIZE, fontSize);
ObjectSetInteger(0, name, OBJPROP_COLOR, textColor);
ObjectSetInteger(0, name, OBJPROP_BGCOLOR, bgColor);
ObjectSetInteger(0, name, OBJPROP_BORDER_COLOR, bgColor);
ObjectSetInteger(0, name, OBJPROP_BACK, false);
ObjectSetInteger(0, name, OBJPROP_STATE, false);
ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
ObjectSetInteger(0, name, OBJPROP_SELECTED, false);
ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
ObjectSetInteger(0, name, OBJPROP_ZORDER, 10);
	}
};

// Block 1249 (btnCloseFull)
class Block285: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block285() {
		__block_number = 285;
		__block_user_number = "1249";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[3] = {286,287,288};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[286].run(285);
			_blocks_[287].run(285);
			_blocks_[288].run(285);
		}
	}

	virtual void _beforeExecute_()
	{

		string name = "btnCloseFull";

string text =  "Close Full" ; 
int x = 41;
int y =  233;
int width =  141;
int height =  39;
color bgColor =  (color)0xFD6E0D;
color textColor = clrWhite;
int fontSize = 12;
ObjectCreate(0, name, OBJ_BUTTON, 0, 0, 0);
ObjectSetString(0, name, OBJPROP_TEXT, text);
ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
ObjectSetInteger(0, name, OBJPROP_XSIZE, width);
ObjectSetInteger(0, name, OBJPROP_YSIZE, height);
ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
ObjectSetInteger(0, name, OBJPROP_ANCHOR, ANCHOR_LEFT_UPPER);
ObjectSetInteger(0, name, OBJPROP_FONTSIZE, fontSize);
ObjectSetInteger(0, name, OBJPROP_COLOR, textColor);
ObjectSetInteger(0, name, OBJPROP_BGCOLOR, bgColor);
ObjectSetInteger(0, name, OBJPROP_BORDER_COLOR, bgColor);
ObjectSetInteger(0, name, OBJPROP_BACK, false);
ObjectSetInteger(0, name, OBJPROP_STATE, false);
ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
ObjectSetInteger(0, name, OBJPROP_SELECTED, false);
ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
ObjectSetInteger(0, name, OBJPROP_ZORDER, 10);
	}
};

// Block 1250 (btnCloseCustom)
class Block286: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block286() {
		__block_number = 286;
		__block_user_number = "1250";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {289,296};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[289].run(286);
			_blocks_[296].run(286);
		}
	}

	virtual void _beforeExecute_()
	{

		string name = "btnCloseCustom";

string text =  "Close "+ c::Close_Custom_Percent + "%" ; 
int x = 41;
int y =  279;
int width =  141;
int height =  39;
color bgColor =  (color)0xFD6E0D;
color textColor = clrWhite;
int fontSize = 12;
ObjectCreate(0, name, OBJ_BUTTON, 0, 0, 0);
ObjectSetString(0, name, OBJPROP_TEXT, text);
ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
ObjectSetInteger(0, name, OBJPROP_XSIZE, width);
ObjectSetInteger(0, name, OBJPROP_YSIZE, height);
ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
ObjectSetInteger(0, name, OBJPROP_ANCHOR, ANCHOR_LEFT_UPPER);
ObjectSetInteger(0, name, OBJPROP_FONTSIZE, fontSize);
ObjectSetInteger(0, name, OBJPROP_COLOR, textColor);
ObjectSetInteger(0, name, OBJPROP_BGCOLOR, bgColor);
ObjectSetInteger(0, name, OBJPROP_BORDER_COLOR, bgColor);
ObjectSetInteger(0, name, OBJPROP_BACK, false);
ObjectSetInteger(0, name, OBJPROP_STATE, false);
ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
ObjectSetInteger(0, name, OBJPROP_SELECTED, false);
ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
ObjectSetInteger(0, name, OBJPROP_ZORDER, 10);
	}
};

// Block 1251 (btnRiskFree)
class Block287: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block287() {
		__block_number = 287;
		__block_user_number = "1251";
		_beforeExecuteEnabled = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		string name = "btnRiskFree";

string text =  "Risk Free" ; 
int x = 207;
int y =  279;
int width =  141;
int height =  39;
color bgColor =  (color)0xFD6E0D;
color textColor = clrWhite;
int fontSize = 12;
ObjectCreate(0, name, OBJ_BUTTON, 0, 0, 0);
ObjectSetString(0, name, OBJPROP_TEXT, text);
ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
ObjectSetInteger(0, name, OBJPROP_XSIZE, width);
ObjectSetInteger(0, name, OBJPROP_YSIZE, height);
ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
ObjectSetInteger(0, name, OBJPROP_ANCHOR, ANCHOR_LEFT_UPPER);
ObjectSetInteger(0, name, OBJPROP_FONTSIZE, fontSize);
ObjectSetInteger(0, name, OBJPROP_COLOR, textColor);
ObjectSetInteger(0, name, OBJPROP_BGCOLOR, bgColor);
ObjectSetInteger(0, name, OBJPROP_BORDER_COLOR, bgColor);
ObjectSetInteger(0, name, OBJPROP_BACK, false);
ObjectSetInteger(0, name, OBJPROP_STATE, false);
ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
ObjectSetInteger(0, name, OBJPROP_SELECTED, false);
ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
ObjectSetInteger(0, name, OBJPROP_ZORDER, 10);
	}
};

// Block 1252 (btnCloseFiftyPercent)
class Block288: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block288() {
		__block_number = 288;
		__block_user_number = "1252";
		_beforeExecuteEnabled = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		string name = "btnCloseFiftyPercent";

string text =  "Close 50%" ; 
int x = 207;
int y =  233;
int width =  141;
int height =  39;
color bgColor =  (color)0xFD6E0D;
color textColor = clrWhite;
int fontSize = 12;
ObjectCreate(0, name, OBJ_BUTTON, 0, 0, 0);
ObjectSetString(0, name, OBJPROP_TEXT, text);
ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
ObjectSetInteger(0, name, OBJPROP_XSIZE, width);
ObjectSetInteger(0, name, OBJPROP_YSIZE, height);
ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
ObjectSetInteger(0, name, OBJPROP_ANCHOR, ANCHOR_LEFT_UPPER);
ObjectSetInteger(0, name, OBJPROP_FONTSIZE, fontSize);
ObjectSetInteger(0, name, OBJPROP_COLOR, textColor);
ObjectSetInteger(0, name, OBJPROP_BGCOLOR, bgColor);
ObjectSetInteger(0, name, OBJPROP_BORDER_COLOR, bgColor);
ObjectSetInteger(0, name, OBJPROP_BACK, false);
ObjectSetInteger(0, name, OBJPROP_STATE, false);
ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
ObjectSetInteger(0, name, OBJPROP_SELECTED, false);
ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
ObjectSetInteger(0, name, OBJPROP_ZORDER, 10);
	}
};

// Block 1253 (btnAuto Break Even)
class Block289: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block289() {
		__block_number = 289;
		__block_user_number = "1253";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {290,297};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[290].run(289);
			_blocks_[297].run(289);
		}
	}

	virtual void _beforeExecute_()
	{

		string name = "btnAutoBreakEven";

string text =  "Auto Break Even" ; 
int x = 41;
int y =  324;
int width =  240;
int height =  39;
color bgColor =  (color)0x548718;
color textColor = clrWhite;
int fontSize = 12;
ObjectCreate(0, name, OBJ_BUTTON, 0, 0, 0);
ObjectSetString(0, name, OBJPROP_TEXT, text);
ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
ObjectSetInteger(0, name, OBJPROP_XSIZE, width);
ObjectSetInteger(0, name, OBJPROP_YSIZE, height);
ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
ObjectSetInteger(0, name, OBJPROP_ANCHOR, ANCHOR_LEFT_UPPER);
ObjectSetInteger(0, name, OBJPROP_FONTSIZE, fontSize);
ObjectSetInteger(0, name, OBJPROP_COLOR, textColor);
ObjectSetInteger(0, name, OBJPROP_BGCOLOR, bgColor);
ObjectSetInteger(0, name, OBJPROP_BORDER_COLOR, bgColor);
ObjectSetInteger(0, name, OBJPROP_BACK, false);
ObjectSetInteger(0, name, OBJPROP_STATE, false);
ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
ObjectSetInteger(0, name, OBJPROP_SELECTED, false);
ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
ObjectSetInteger(0, name, OBJPROP_ZORDER, 10);
	}
};

// Block 1254 (btnAddPartialTakeProfit)
class Block290: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block290() {
		__block_number = 290;
		__block_user_number = "1254";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {291};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[291].run(290);
		}
	}

	virtual void _beforeExecute_()
	{

		string name = "btnAddPartialTakeProfit";

string text =  "Add Partial Take Profit" ; 
int x = 41;
int y =  368;
int width =  240;
int height =  39;
color bgColor =  (color)0xFD6E0D;
color textColor = clrWhite;
int fontSize = 12;
ObjectCreate(0, name, OBJ_BUTTON, 0, 0, 0);
ObjectSetString(0, name, OBJPROP_TEXT, text);
ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
ObjectSetInteger(0, name, OBJPROP_XSIZE, width);
ObjectSetInteger(0, name, OBJPROP_YSIZE, height);
ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
ObjectSetInteger(0, name, OBJPROP_ANCHOR, ANCHOR_LEFT_UPPER);
ObjectSetInteger(0, name, OBJPROP_FONTSIZE, fontSize);
ObjectSetInteger(0, name, OBJPROP_COLOR, textColor);
ObjectSetInteger(0, name, OBJPROP_BGCOLOR, bgColor);
ObjectSetInteger(0, name, OBJPROP_BORDER_COLOR, bgColor);
ObjectSetInteger(0, name, OBJPROP_BACK, false);
ObjectSetInteger(0, name, OBJPROP_STATE, false);
ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
ObjectSetInteger(0, name, OBJPROP_SELECTED, false);
ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
ObjectSetInteger(0, name, OBJPROP_ZORDER, 10);
	}
};

// Block 1255 (Draw Comment Edit Field)
class Block291: public MDL_ChartDrawEditField<bool,bool,string,int,int,MDLIC_text_text,string,string,int,int,int,int,color,color,int,bool,color,bool,bool,bool,bool,int,string>
{

	public: /* Constructor */
	Block291() {
		__block_number = 291;
		__block_user_number = "1255";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {292};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		ObjName = "txtPositionComment";
		ObjX = 138;
		ObjY = 187;
		ObjFontSize = 12;
		ObjXsize = 211;
		ObjYsize = 39;
		ObjBack = false;
		ObjHidden = true;
		ObjZorder = 1000;
	}

	public: /* Custom methods */
	virtual string _ObjText_() {
		ObjText.Text = v::position_comment;

		return ObjText._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[292].run(291);
		}
	}

	virtual void _beforeExecute_()
	{

		ObjAlign = (int)ALIGN_CENTER;
		ObjBgColor = (color)clrWhite;
		ObjBorderColor = (color)clrNONE;
		ObjCorner = (int)CORNER_LEFT_UPPER;
		ObjColor = (color)clrBlack;
	}
};

// Block 1256 (Draw Risk percent Edit field)
class Block292: public MDL_ChartDrawEditField<bool,bool,string,int,int,MDLIC_text_text,string,string,int,int,int,int,color,color,int,bool,color,bool,bool,bool,bool,int,string>
{

	public: /* Constructor */
	Block292() {
		__block_number = 292;
		__block_user_number = "1256";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {293,295};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		ObjName = "txtRiskPercent";
		ObjX = 207;
		ObjY = 140;
		ObjFontSize = 14;
		ObjXsize = 72;
		ObjYsize = 42;
		ObjBack = false;
		ObjHidden = true;
		ObjZorder = 1000;
	}

	public: /* Custom methods */
	virtual string _ObjText_() {
		ObjText.Text = v::risk_percent;

		return ObjText._execute_();
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[293].run(292);
			_blocks_[295].run(292);
		}
	}

	virtual void _beforeExecute_()
	{

		ObjAlign = (int)ALIGN_CENTER;
		ObjBgColor = (color)clrWhite;
		ObjBorderColor = (color)clrNONE;
		ObjCorner = (int)CORNER_LEFT_UPPER;
		ObjColor = (color)clrBlack;
	}
};

// Block 1257 (btnRiskPlus)
class Block293: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block293() {
		__block_number = 293;
		__block_user_number = "1257";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {294};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[294].run(293);
		}
	}

	virtual void _beforeExecute_()
	{

		string name = "btnRiskPlus";

string text =  "+" ; 
int x = 288;
int y =  142;
int width =  18;
int height =  18;
color bgColor =  (color)0x548718;
color textColor = clrWhite;
int fontSize = 12;
ObjectCreate(0, name, OBJ_BUTTON, 0, 0, 0);
ObjectSetString(0, name, OBJPROP_TEXT, text);
ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
ObjectSetInteger(0, name, OBJPROP_XSIZE, width);
ObjectSetInteger(0, name, OBJPROP_YSIZE, height);
ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
ObjectSetInteger(0, name, OBJPROP_ANCHOR, ANCHOR_LEFT_UPPER);
ObjectSetInteger(0, name, OBJPROP_FONTSIZE, fontSize);
ObjectSetInteger(0, name, OBJPROP_COLOR, textColor);
ObjectSetInteger(0, name, OBJPROP_BGCOLOR, bgColor);
ObjectSetInteger(0, name, OBJPROP_BORDER_COLOR, bgColor);
ObjectSetInteger(0, name, OBJPROP_BACK, false);
ObjectSetInteger(0, name, OBJPROP_STATE, false);
ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
ObjectSetInteger(0, name, OBJPROP_SELECTED, false);
ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
ObjectSetInteger(0, name, OBJPROP_ZORDER, 10);
	}
};

// Block 1258 (btnRiskMinus)
class Block294: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block294() {
		__block_number = 294;
		__block_user_number = "1258";
		_beforeExecuteEnabled = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		string name = "btnRiskMinus";

string text =  "-" ; 
int x = 288;
int y =  162;
int width =  18;
int height =  18;
color bgColor =  (color)0x548718;
color textColor = clrWhite;
int fontSize = 12;
ObjectCreate(0, name, OBJ_BUTTON, 0, 0, 0);
ObjectSetString(0, name, OBJPROP_TEXT, text);
ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
ObjectSetInteger(0, name, OBJPROP_XSIZE, width);
ObjectSetInteger(0, name, OBJPROP_YSIZE, height);
ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
ObjectSetInteger(0, name, OBJPROP_ANCHOR, ANCHOR_LEFT_UPPER);
ObjectSetInteger(0, name, OBJPROP_FONTSIZE, fontSize);
ObjectSetInteger(0, name, OBJPROP_COLOR, textColor);
ObjectSetInteger(0, name, OBJPROP_BGCOLOR, bgColor);
ObjectSetInteger(0, name, OBJPROP_BORDER_COLOR, bgColor);
ObjectSetInteger(0, name, OBJPROP_BACK, false);
ObjectSetInteger(0, name, OBJPROP_STATE, false);
ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
ObjectSetInteger(0, name, OBJPROP_SELECTED, false);
ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
ObjectSetInteger(0, name, OBJPROP_ZORDER, 10);
	}
};

// Block 1260 (Draw % Text)
class Block295: public MDL_ChartDrawText<bool,bool,string,ENUM_OBJECT,MDLIC_value_time,datetime,MDLIC_candles_candles,double,int,int,MDLIC_text_text,string,string,int,double,ENUM_BASE_CORNER,int,color,bool,bool,bool,bool,int,string>
{

	public: /* Constructor */
	Block295() {
		__block_number = 295;
		__block_user_number = "1260";
		_beforeExecuteEnabled = true;

		// IC input parameters
		ObjTime1.ModeTime = 3;
		ObjTime1.TimeCandleID = 0;
		ObjPrice1.TimeStamp = "";
		ObjText.Text = "%";
		// Block input parameters
		ObjectPerBar = false;
		ObjName = "lblPercent";
		ObjX = 315;
		ObjY = 147;
		ObjFontSize = 16;
		ObjSelectable = false;
		ObjHidden = true;
	}

	public: /* Custom methods */
	virtual datetime _ObjTime1_() {return ObjTime1._execute_();}
	virtual double _ObjPrice1_() {
		ObjPrice1.Symbol = CurrentSymbol();
		ObjPrice1.Period = CurrentTimeframe();

		return ObjPrice1._execute_();
	}
	virtual string _ObjText_() {return ObjText._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	   if (value == 1) {
			_blocks_[302].run(295);
		}
	}

	virtual void _beforeExecute_()
	{

		ObjectType = (ENUM_OBJECT)OBJ_LABEL;
		ObjCorner = (ENUM_BASE_CORNER)CORNER_LEFT_UPPER;
		ObjAnchor = (int)ANCHOR_LEFT_UPPER;
		ObjColor = (color)clrWhite;
	}
};

// Block 1698 (btnAuto Break Even Set)
class Block296: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block296() {
		__block_number = 296;
		__block_user_number = "1698";
		_beforeExecuteEnabled = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		string name = "btnAutoBreakEvenSet";

string text =  "Set" ; 
int x = 289;
int y =  324;
int width =  60;
int height =  39;
color bgColor =  (color)0x548718;
color textColor = clrWhite;
int fontSize = 12;
ObjectCreate(0, name, OBJ_BUTTON, 0, 0, 0);
ObjectSetString(0, name, OBJPROP_TEXT, text);
ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
ObjectSetInteger(0, name, OBJPROP_XSIZE, width);
ObjectSetInteger(0, name, OBJPROP_YSIZE, height);
ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
ObjectSetInteger(0, name, OBJPROP_ANCHOR, ANCHOR_LEFT_UPPER);
ObjectSetInteger(0, name, OBJPROP_FONTSIZE, fontSize);
ObjectSetInteger(0, name, OBJPROP_COLOR, textColor);
ObjectSetInteger(0, name, OBJPROP_BGCOLOR, bgColor);
ObjectSetInteger(0, name, OBJPROP_BORDER_COLOR, bgColor);
ObjectSetInteger(0, name, OBJPROP_BACK, false);
ObjectSetInteger(0, name, OBJPROP_STATE, false);
ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
ObjectSetInteger(0, name, OBJPROP_SELECTED, false);
ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
ObjectSetInteger(0, name, OBJPROP_ZORDER, 10);
	}
};

// Block 1699 (btnAddPartialTakeProfitSet)
class Block297: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block297() {
		__block_number = 297;
		__block_user_number = "1699";
		_beforeExecuteEnabled = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		string name = "btnAddPartialTakeProfitSet";

string text =  "Set" ; 
int x = 289;
int y =  368;
int width =  60;
int height =  39;
color bgColor =  (color)0xFD6E0D;
color textColor = clrWhite;
int fontSize = 12;
ObjectCreate(0, name, OBJ_BUTTON, 0, 0, 0);
ObjectSetString(0, name, OBJPROP_TEXT, text);
ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
ObjectSetInteger(0, name, OBJPROP_XSIZE, width);
ObjectSetInteger(0, name, OBJPROP_YSIZE, height);
ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
ObjectSetInteger(0, name, OBJPROP_ANCHOR, ANCHOR_LEFT_UPPER);
ObjectSetInteger(0, name, OBJPROP_FONTSIZE, fontSize);
ObjectSetInteger(0, name, OBJPROP_COLOR, textColor);
ObjectSetInteger(0, name, OBJPROP_BGCOLOR, bgColor);
ObjectSetInteger(0, name, OBJPROP_BORDER_COLOR, bgColor);
ObjectSetInteger(0, name, OBJPROP_BACK, false);
ObjectSetInteger(0, name, OBJPROP_STATE, false);
ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
ObjectSetInteger(0, name, OBJPROP_SELECTED, false);
ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
ObjectSetInteger(0, name, OBJPROP_ZORDER, 10);
	}
};

// Block 2283 (btnMinimize)
class Block298: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block298() {
		__block_number = 298;
		__block_user_number = "2283";
		_beforeExecuteEnabled = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		string name = "btnMinimize";

string text =  "-" ; 
int x = 320;
int y =  48;
int width =  30;
int height =  30;
color bgColor =  (color)0x7D756C;
color textColor = clrWhite;
int fontSize = 18;
ObjectCreate(0, name, OBJ_BUTTON, 0, 0, 0);
ObjectSetString(0, name, OBJPROP_TEXT, text);
ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
ObjectSetInteger(0, name, OBJPROP_XSIZE, width);
ObjectSetInteger(0, name, OBJPROP_YSIZE, height);
ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
ObjectSetInteger(0, name, OBJPROP_ANCHOR, ANCHOR_LEFT_UPPER);
ObjectSetInteger(0, name, OBJPROP_FONTSIZE, fontSize);
ObjectSetInteger(0, name, OBJPROP_COLOR, textColor);
ObjectSetInteger(0, name, OBJPROP_BGCOLOR, bgColor);
ObjectSetInteger(0, name, OBJPROP_BORDER_COLOR, bgColor);
ObjectSetInteger(0, name, OBJPROP_BACK, false);
ObjectSetInteger(0, name, OBJPROP_STATE, false);
ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
ObjectSetInteger(0, name, OBJPROP_SELECTED, false);
ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
ObjectSetInteger(0, name, OBJPROP_ZORDER, 10);
	}
};

// Block 2284 (Custom MQL code)
class Block299: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block299() {
		__block_number = 299;
		__block_user_number = "2284";
		_beforeExecuteEnabled = true;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		int x1 = 20;
int y1 = 30;
int x2 = 370;
int y2 = 420;
int borderWidth = 2; // Width of the border in pixels

ObjectSetInteger(0, "ButtonBorder", OBJPROP_XSIZE, (x2 - x1) + (2 * borderWidth));
ObjectSetInteger(0, "ButtonBorder", OBJPROP_YSIZE, (y2 - y1) + (2 * borderWidth));
ObjectSetInteger(0, "ButtonBackground", OBJPROP_XSIZE, (x2 - x1) + (2 * borderWidth));
ObjectSetInteger(0, "ButtonBackground", OBJPROP_YSIZE, (y2 - y1) + (2 * borderWidth));
	}
};

// Block 2291 (Set Flag (true-false))
class Block300: public MDL_FlagSetB<string,bool>
{

	public: /* Constructor */
	Block300() {
		__block_number = 300;
		__block_user_number = "2291";

		// Block input parameters
		FlagName = "firstClickOnCommentEdit";
		FlagValue = false;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}
};

// Block 2293 (Custom MQL code)
class Block301: public MDL_CustomCode<bool>
{

	public: /* Constructor */
	Block301() {
		__block_number = 301;
		__block_user_number = "2293";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {38,54};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[38].run(301);
			_blocks_[54].run(301);
		}
	}

	virtual void _beforeExecute_()
	{

		ObjectDelete(0, "ButtonBorder");
ObjectDelete(0, "ButtonBackground");
ObjectDelete(0, "btnRiskFree");
ObjectDelete(0, "btnCloseAll");
ObjectDelete(0, "btnPendingOrder");
ObjectDelete(0, "btnOpenCalc");
ObjectDelete(0, "btnOpenTrade");
ObjectDelete(0, "lineSL");
ObjectDelete(0, "lineTP");
ObjectDelete(0, "linePendingOrder");

ObjectDelete(0, "ButtonBorder");
ObjectDelete(0, "ButtonBackground");
ObjectDelete(0, "btnCloseFull");
ObjectDelete(0, "btnCloseFiftyPercent");
ObjectDelete(0, "btnCloseCustom");
ObjectDelete(0, "btnAutoBreakEven");
ObjectDelete(0, "btnAddPartialTakeProfit");
ObjectDelete(0, "txtPositionComment");
ObjectDelete(0, "txtRiskPercent");
ObjectDelete(0, "btnRiskPlus");
ObjectDelete(0, "btnRiskMinus");
ObjectDelete(0, "lblPercent");
ObjectDelete(0, "lblHeader");
ObjectDelete(0, "btnAutoBreakEvenSet");
ObjectDelete(0, "btnAddPartialTakeProfitSet");
ObjectDelete(0, "lineTP");
ObjectDelete(0, "btnMinimize");
ObjectDelete(0, "lineTP1");
ObjectDelete(0, "lineTP2");
ObjectDelete(0, "lineTP3");
ObjectDelete(0, "lineTP4");
ObjectDelete(0, "lineTP5");
ObjectDelete(0, "lbllineTP1");
ObjectDelete(0, "lbllineTP2");
ObjectDelete(0, "lbllineTP3");
ObjectDelete(0, "lbllineTP4");
ObjectDelete(0, "lbllineTP5");

ObjectDelete(0, "lblLineSL");
ObjectDelete(0, "lblLineTP");

ObjectDelete(0, "lineBEtriger");
ObjectDelete(0, "lineBEtarget");
ObjectDelete(0, "lbllineBEtriger");
ObjectDelete(0, "lbllineBEtarget");


ObjectDelete(0, "lblNote");
	}
};

// Block 2294 (Draw Text)
class Block302: public MDL_ChartDrawText<bool,bool,string,ENUM_OBJECT,MDLIC_value_time,datetime,MDLIC_candles_candles,double,int,int,MDLIC_text_text,string,string,int,double,ENUM_BASE_CORNER,int,color,bool,bool,bool,bool,int,string>
{

	public: /* Constructor */
	Block302() {
		__block_number = 302;
		__block_user_number = "2294";
		_beforeExecuteEnabled = true;

		// IC input parameters
		ObjTime1.ModeTime = 3;
		ObjTime1.TimeCandleID = 0;
		ObjPrice1.TimeStamp = "";
		ObjText.Text = "Comment";
		// Block input parameters
		ObjectPerBar = false;
		ObjName = "lblNote";
		ObjX = 41;
		ObjY = 194;
		ObjFont = "Arial Bold";
		ObjFontSize = 12;
		ObjSelectable = false;
		ObjHidden = true;
	}

	public: /* Custom methods */
	virtual datetime _ObjTime1_() {return ObjTime1._execute_();}
	virtual double _ObjPrice1_() {
		ObjPrice1.Symbol = CurrentSymbol();
		ObjPrice1.Period = CurrentTimeframe();

		return ObjPrice1._execute_();
	}
	virtual string _ObjText_() {return ObjText._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}

	virtual void _beforeExecute_()
	{

		ObjectType = (ENUM_OBJECT)OBJ_LABEL;
		ObjCorner = (ENUM_BASE_CORNER)CORNER_LEFT_UPPER;
		ObjAnchor = (int)ANCHOR_LEFT_UPPER;
		ObjColor = (color)clrWhite;
	}
};

// Block 2297 (Delete BE target line)
class Block303: public MDL_ChartDeleteObjects<string,string,color,string,int,int>
{

	public: /* Constructor */
	Block303() {
		__block_number = 303;
		__block_user_number = "2297";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {304};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		NameContains = "lineBEtarget";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[304].run(303);
		}
	}

	virtual void _beforeExecute_()
	{

		ObjColor = (color)EMPTY_VALUE;
	}
};

// Block 2298 (Delete BE triger line)
class Block304: public MDL_ChartDeleteObjects<string,string,color,string,int,int>
{

	public: /* Constructor */
	Block304() {
		__block_number = 304;
		__block_user_number = "2298";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {305};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		NameContains = "lineBEtriger";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[305].run(304);
		}
	}

	virtual void _beforeExecute_()
	{

		ObjColor = (color)EMPTY_VALUE;
	}
};

// Block 2299 (Set Flag (true-false))
class Block305: public MDL_FlagSetB<string,bool>
{

	public: /* Constructor */
	Block305() {
		__block_number = 305;
		__block_user_number = "2299";

		// Block input parameters
		FlagName = "shouldMoveBE";
		FlagValue = false;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}
};

// Block 2300 (Formula)
class Block306: public MDL_Formula_15<MDLIC_inloop_OrderStopLoss,double,string,MDLIC_inloop_OrderProfit,double>
{

	public: /* Constructor */
	Block306() {
		__block_number = 306;
		__block_user_number = "2300";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {149};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Lo.Mode = "pips";
		Ro.ModeProfit = 3;
	}

	public: /* Custom methods */
	virtual double _Lo_() {return Lo._execute_();}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[149].run(306);
		}
	}
};

// Block 2301 (Formula)
class Block307: public MDL_Formula_16<MDLIC_inloop_OrderStopLoss,double,string,MDLIC_inloop_OrderProfit,double>
{

	public: /* Constructor */
	Block307() {
		__block_number = 307;
		__block_user_number = "2301";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {121};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Lo.Mode = "pips";
		Ro.ModeProfit = 3;
	}

	public: /* Custom methods */
	virtual double _Lo_() {return Lo._execute_();}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[121].run(307);
		}
	}
};

// Block 2302 (Delete tp target lines)
class Block308: public MDL_ChartDeleteObjects<string,string,color,string,int,int>
{

	public: /* Constructor */
	Block308() {
		__block_number = 308;
		__block_user_number = "2302";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {313};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		NameContains = "lineTP5";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[313].run(308);
		}
	}

	virtual void _beforeExecute_()
	{

		ObjColor = (color)EMPTY_VALUE;
	}
};

// Block 2303 (Delete tp target lines)
class Block309: public MDL_ChartDeleteObjects<string,string,color,string,int,int>
{

	public: /* Constructor */
	Block309() {
		__block_number = 309;
		__block_user_number = "2303";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {308};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		NameContains = "lineTP4";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[308].run(309);
		}
	}

	virtual void _beforeExecute_()
	{

		ObjColor = (color)EMPTY_VALUE;
	}
};

// Block 2304 (Delete tp target lines)
class Block310: public MDL_ChartDeleteObjects<string,string,color,string,int,int>
{

	public: /* Constructor */
	Block310() {
		__block_number = 310;
		__block_user_number = "2304";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {309};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		NameContains = "lineTP3";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[309].run(310);
		}
	}

	virtual void _beforeExecute_()
	{

		ObjColor = (color)EMPTY_VALUE;
	}
};

// Block 2305 (Delete tp target lines)
class Block311: public MDL_ChartDeleteObjects<string,string,color,string,int,int>
{

	public: /* Constructor */
	Block311() {
		__block_number = 311;
		__block_user_number = "2305";
		_beforeExecuteEnabled = true;

		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {310};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
		// Block input parameters
		NameContains = "lineTP2";
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[310].run(311);
		}
	}

	virtual void _beforeExecute_()
	{

		ObjColor = (color)EMPTY_VALUE;
	}
};

// Block 2306 (Set Flag (true-false))
class Block312: public MDL_FlagSetB<string,bool>
{

	public: /* Constructor */
	Block312() {
		__block_number = 312;
		__block_user_number = "2306";

		// Block input parameters
		FlagName = "shouldMoveBE";
		FlagValue = false;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}
};

// Block 2307 (Set Flag (true-false))
class Block313: public MDL_FlagSetB<string,bool>
{

	public: /* Constructor */
	Block313() {
		__block_number = 313;
		__block_user_number = "2307";

		// Block input parameters
		FlagName = "shouldTakeProfit";
		FlagValue = false;
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
	}
};

// Block 2308 (order is buy)
class Block314: public MDL_LoopCheckType<string,string>
{

	public: /* Constructor */
	Block314() {
		__block_number = 314;
		__block_user_number = "2308";


		// Fill the list of outbound blocks
		int ___outbound_blocks[2] = {315,316};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);
	}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 0) {
			_blocks_[316].run(314);
		}
		else if (value == 1) {
			_blocks_[315].run(314);
		}
	}
};

// Block 2309 (Conditionposition is in profit)
class Block315: public MDL_Condition<MDLIC_prices_prices,double,string,MDLIC_inloop_OrderOpenPrice,double,int>
{

	public: /* Constructor */
	Block315() {
		__block_number = 315;
		__block_user_number = "2309";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {306};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Lo.Price = "MID";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Symbol = CurrentSymbol();

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[306].run(315);
		}
	}
};

// Block 2310 (Conditionposition is in profit)
class Block316: public MDL_Condition<MDLIC_prices_prices,double,string,MDLIC_inloop_OrderOpenPrice,double,int>
{

	public: /* Constructor */
	Block316() {
		__block_number = 316;
		__block_user_number = "2310";


		// Fill the list of outbound blocks
		int ___outbound_blocks[1] = {306};
		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// IC input parameters
		Lo.Price = "MID";
		// Block input parameters
		compare = "<";
	}

	public: /* Custom methods */
	virtual double _Lo_() {
		Lo.Symbol = CurrentSymbol();

		return Lo._execute_();
	}
	virtual double _Ro_() {return Ro._execute_();}

	public: /* Callback & Run */
	virtual void _callback_(int value) {
		if (value == 1) {
			_blocks_[306].run(316);
		}
	}
};


/************************************************************************************************************************/
// +------------------------------------------------------------------------------------------------------------------+ //
// |                                                   Functions                                                      | //
// |                                 System and Custom functions used in the program                                  | //
// +------------------------------------------------------------------------------------------------------------------+ //
/************************************************************************************************************************/


double AccountBalance()
{
	return NormalizeDouble(AccountInfoDouble(ACCOUNT_BALANCE), 2);
}

double AccountBalanceAtStart()
{
	// This function MUST be run once at pogram's start
	static double memory = 0;

	if (memory == 0)
	{
		memory = NormalizeDouble(AccountInfoDouble(ACCOUNT_BALANCE), 2);
	}

	return memory;
}

double AccountEquity()
{
	return AccountInfoDouble(ACCOUNT_EQUITY);
}

double AccountFreeMargin()
{
	return AccountInfoDouble(ACCOUNT_FREEMARGIN);
}
double AccountUsedMargin()
{
	return AccountInfoDouble(ACCOUNT_MARGIN);
}
double AlignLots(string symbol, double lots, double lowerlots = 0.0, double upperlots = 0.0)
{
	double LotStep = SymbolInfoDouble(symbol, SYMBOL_VOLUME_STEP);
	double LotSize = SymbolInfoDouble(symbol, SYMBOL_TRADE_CONTRACT_SIZE);
	double MinLots = SymbolInfoDouble(symbol, SYMBOL_VOLUME_MIN);
	double MaxLots = SymbolInfoDouble(symbol, SYMBOL_VOLUME_MAX);

	if (LotStep > MinLots) MinLots = LotStep;

	if (lots == EMPTY_VALUE) {lots = 0.0;}

	lots = MathRound(lots / LotStep) * LotStep;

	if (lots < MinLots) {lots = MinLots;}
	if (lots > MaxLots) {lots = MaxLots;}

	if (lowerlots > 0.0)
	{
		lowerlots = MathRound(lowerlots / LotStep) * LotStep;
		if (lots < lowerlots) {lots = lowerlots;}
	}

	if (upperlots > 0.0)
	{
		upperlots = MathRound(upperlots / LotStep) * LotStep;
		if (lots > upperlots) {lots = upperlots;}
	}

	return lots;
}

double AlignStopLoss(
	string symbol,
	int type,
	double price,
	double slo = 0.0, // original sl, used when modifying
	double sll = 0.0,
	double slp = 0.0,
	bool consider_freezelevel = false
	)
{
	double sl = 0.0;
	
	if (MathAbs(sll) == EMPTY_VALUE) {sll = 0.0;}
	if (MathAbs(slp) == EMPTY_VALUE) {slp = 0.0;}

	if (sll == 0.0 && slp == 0.0)
	{
		return 0.0;
	}

	if (price <= 0.0)
	{
		Print(__FUNCTION__ + " error: No price entered");

		return -1;
	}

	double point = SymbolInfoDouble(symbol, SYMBOL_POINT);
	int digits   = (int)SymbolInfoInteger(symbol, SYMBOL_DIGITS);
	slp          = slp * PipValue(symbol) * point;

	//-- buy-sell identifier ---------------------------------------------
	int bs = 1;

	if (
		   type == ORDER_TYPE_SELL
		|| type == ORDER_TYPE_SELL_STOP
		|| type == ORDER_TYPE_SELL_LIMIT
		|| type == ORDER_TYPE_SELL_STOP_LIMIT
		)
	{
		bs = -1;
	}

	//-- prices that will be used ----------------------------------------
	double askbid = price;
	double bidask = price;

	if (type < 2)
	{
		double ask = SymbolInfoDouble(symbol, SYMBOL_ASK);
		double bid = SymbolInfoDouble(symbol, SYMBOL_BID);

		askbid = ask;
		bidask = bid;

		if (bs < 0)
		{
		  askbid = bid;
		  bidask = ask;
		}
	}

	//-- build sl level -------------------------------------------------- 
	if (sll == 0.0 && slp != 0.0) {sll = price;}

	if (sll > 0.0) {sl = sll - slp * bs;}

	if (sl < 0.0)
	{
		return -1;
	}

	sl  = NormalizeDouble(sl, digits);
	slo = NormalizeDouble(slo, digits);

	if (sl == slo)
	{
		return sl;
	}

	//-- build limit levels ----------------------------------------------
	double minstops = (double)SymbolInfoInteger(symbol, SYMBOL_TRADE_STOPS_LEVEL);

	if (consider_freezelevel == true)
	{
		double freezelevel = (double)SymbolInfoInteger(symbol, SYMBOL_TRADE_FREEZE_LEVEL);

		if (freezelevel > minstops) {minstops = freezelevel;}
	}

	minstops = NormalizeDouble(minstops * point,digits);

	double sllimit = bidask - minstops * bs; // SL min price level

	//-- check and align sl, print errors --------------------------------
	//-- do not do it when the stop is the same as the original
	if (sl > 0.0 && sl != slo)
	{
		if ((bs > 0 && sl > askbid) || (bs < 0 && sl < askbid))
		{
			string abstr = "";

			if (bs > 0) {abstr = "Bid";} else {abstr = "Ask";}

			Print(
				"Error: Invalid SL requested (",
				DoubleToStr(sl, digits),
				" for ", abstr, " price ",
				bidask,
				")"
			);

			return -1;
		}
		else if ((bs > 0 && sl > sllimit) || (bs < 0 && sl < sllimit))
		{
			if (USE_VIRTUAL_STOPS)
			{
				return sl;
			}

			Print(
				"Warning: Too short SL requested (",
				DoubleToStr(sl, digits),
				" or ",
				DoubleToStr(MathAbs(sl - askbid) / point, 0),
				" points), minimum will be taken (",
				DoubleToStr(sllimit, digits),
				" or ",
				DoubleToStr(MathAbs(askbid - sllimit) / point, 0),
				" points)"
			);

			sl = sllimit;

			return sl;
		}
	}

	// align by the ticksize
	double ticksize = SymbolInfoDouble(symbol, SYMBOL_TRADE_TICK_SIZE);
	sl = MathRound(sl / ticksize) * ticksize;

	return sl;
}

double AlignTakeProfit(
	string symbol,
	int type,
	double price,
	double tpo = 0.0, // original tp, used when modifying
	double tpl = 0.0,
	double tpp = 0.0,
	bool consider_freezelevel = false
	)
{
	double tp = 0.0;
	
	if (MathAbs(tpl) == EMPTY_VALUE) {tpl = 0.0;}
	if (MathAbs(tpp) == EMPTY_VALUE) {tpp = 0.0;}

	if (tpl == 0.0 && tpp == 0.0)
	{
		return 0.0;
	}

	if (price <= 0.0)
	{
		Print(__FUNCTION__ + " error: No price entered");

		return -1;
	}

	double point = SymbolInfoDouble(symbol, SYMBOL_POINT);
	int digits   = (int)SymbolInfoInteger(symbol, SYMBOL_DIGITS);
	tpp          = tpp * PipValue(symbol) * point;
	
	//-- buy-sell identifier ---------------------------------------------
	int bs = 1;

	if (
		   type == ORDER_TYPE_SELL
		|| type == ORDER_TYPE_SELL_STOP
		|| type == ORDER_TYPE_SELL_LIMIT
		|| type == ORDER_TYPE_SELL_STOP_LIMIT
		)
	{
		bs = -1;
	}
	
	//-- prices that will be used ----------------------------------------
	double askbid = price;
	double bidask = price;
	
	if (type < 2)
	{
		double ask = SymbolInfoDouble(symbol, SYMBOL_ASK);
		double bid = SymbolInfoDouble(symbol, SYMBOL_BID);
		
		askbid = ask;
		bidask = bid;

		if (bs < 0)
		{
		  askbid = bid;
		  bidask = ask;
		}
	}
	
	//-- build tp level --------------------------------------------------- 
	if (tpl == 0.0 && tpp != 0.0) {tpl = price;}

	if (tpl > 0.0) {tp = tpl + tpp * bs;}
	
	if (tp < 0.0)
	{
		return -1;
	}

	tp  = NormalizeDouble(tp, digits);
	tpo = NormalizeDouble(tpo, digits);

	if (tp == tpo)
	{
		return tp;
	}
	
	//-- build limit levels ----------------------------------------------
	double minstops = (double)SymbolInfoInteger(symbol, SYMBOL_TRADE_STOPS_LEVEL);

	if (consider_freezelevel == true)
	{
		double freezelevel = (double)SymbolInfoInteger(symbol, SYMBOL_TRADE_FREEZE_LEVEL);

		if (freezelevel > minstops) {minstops = freezelevel;}
	}

	minstops = NormalizeDouble(minstops * point,digits);
	
	double tplimit = bidask + minstops * bs; // TP min price level
	
	//-- check and align tp, print errors --------------------------------
	//-- do not do it when the stop is the same as the original
	if (tp > 0.0 && tp != tpo)
	{
		if ((bs > 0 && tp < bidask) || (bs < 0 && tp > bidask))
		{
			string abstr = "";

			if (bs > 0) {abstr = "Bid";} else {abstr = "Ask";}

			Print(
				"Error: Invalid TP requested (",
				DoubleToStr(tp, digits),
				" for ", abstr, " price ",
				bidask,
				")"
			);

			return -1;
		}
		else if ((bs > 0 && tp < tplimit) || (bs < 0 && tp > tplimit))
		{
			if (USE_VIRTUAL_STOPS)
			{
				return tp;
			}

			Print(
				"Warning: Too short TP requested (",
				DoubleToStr(tp, digits),
				" or ",
				DoubleToStr(MathAbs(tp - askbid) / point, 0),
				" points), minimum will be taken (",
				DoubleToStr(tplimit, digits),
				" or ",
				DoubleToStr(MathAbs(askbid - tplimit) / point, 0),
				" points)"
			);

			tp = tplimit;

			return tp;
		}
	}
	
	// align by the ticksize
	double ticksize = SymbolInfoDouble(symbol, SYMBOL_TRADE_TICK_SIZE);
	tp = MathRound(tp / ticksize) * ticksize;
	
	return tp;
}

template<typename T>
bool ArrayEnsureValue(T &array[], T value)
{
	int size   = ArraySize(array);

	if (size > 0)
	{
		if (InArray(array, value))
		{
			// value found -> exit
			return false; // no value added
		}
	}

	// value does not exists -> add it
	ArrayResize(array, size+1);
	array[size] = value;

	return true; // value added
}

template<typename T>
int ArraySearch(T &array[], T value)
{
	int index = -1;
	int size  = ArraySize(array);

	for (int i = 0; i < size; i++)
	{
		if (array[i] == value)
		{
			index = i;
			break;
		}  
	}

   return index;
}

template<typename T>
bool ArrayStripKey(T &array[], int key)
{
	int x    = 0;
	int size = ArraySize(array);

	for (int i=0; i<size; i++)
	{
		if (i != key)
		{
			array[x] = array[i];
			x++;
		}
	}

	if (x < size)
	{
		ArrayResize(array, x);
		
		return true; // stripped
	}

	return false; // not stripped
}

template<typename T>
bool ArrayStripValue(T &array[], T value)
{
	int x    = 0;
	int size = ArraySize(array);

	for (int i=0; i<size; i++)
	{
		if (array[i] != value)
		{
			array[x] = array[i];
			x++;
		}
	}

	if (x < size)
	{
		ArrayResize(array, x);
		
		return true; // stripped
	}

	return false; // not stripped
}

double Bet1326(
	string group,
	string symbol,
	int pool,
	double initialLots,
	bool reverse = false
) {  
	double info[];
	GetBetTradesInfo(info, group, symbol, pool, false);

	double lots         = info[0];
	double profitOrLoss = info[1]; // 0 - unknown, 1 - profit, -1 - loss

	//-- 1-3-2-6 Logic
	double minLot = SymbolInfoDouble(symbol, SYMBOL_VOLUME_MIN);

	if (initialLots < minLot)
	{
		initialLots = minLot;  
	}

	if (lots == 0)
	{
		lots = initialLots;
	}
	else
	{
		if (
			   (reverse == false && profitOrLoss == 1)
			|| (reverse == true && profitOrLoss == -1)
		) {
			double div = lots / initialLots;

			     if (div < 1.5) {lots = initialLots * 3;}
			else if (div < 2.5) {lots = initialLots * 6;}
			else if (div < 3.5) {lots = initialLots * 2;}
			else {lots = initialLots;}
		}
		else
		{
			lots = initialLots;
		}
	}

	return lots;
}

double BetDalembert(
	string group,
	string symbol,
	int pool,
	double initialLots,
	double reverse = false
) {  
	double info[];
	GetBetTradesInfo(info, group, symbol, pool, false);

	double lots         = info[0];
	double profitOrLoss = info[1]; // 0 - unknown, 1 - profit, -1 - loss

	//-- Dalembert Logic
	double minLot = SymbolInfoDouble(symbol, SYMBOL_VOLUME_MIN);

	if (initialLots < minLot)
	{
		initialLots = minLot;  
	}

	if (lots == 0)
	{
		lots = initialLots;
	}
	else
	{
		if (
			   (reverse == 0 && profitOrLoss == 1)
			|| (reverse == 1 && profitOrLoss == -1)
		) {
			lots = lots - initialLots;
			if (lots < initialLots) {lots = initialLots;}
		}
		else
		{
			lots = lots + initialLots;
		}
	}

	return lots;
}

double BetFibonacci(
	string group,
	string symbol,
	int pool,
	double initialLots
) {
	double info[];
	GetBetTradesInfo(info, group, symbol, pool, false);

	double lots         = info[0];
	double profitOrLoss = info[1]; // 0 - unknown, 1 - profit, -1 - loss

	//-- Fibonacci Logic
	double minLot = SymbolInfoDouble(symbol, SYMBOL_VOLUME_MIN);

	if (initialLots < minLot)
	{
		initialLots = minLot;  
	}

	if (lots == 0)
	{
		lots = initialLots;
	}
	else
	{  
		int fibo1 = 1;
		int fibo2 = 0;
		int fibo3 = 0;
		int fibo4 = 0;
		double div = lots / initialLots;

		if (div <= 0) {div = 1;}

		while (true)
		{
			fibo1 = fibo1 + fibo2;
			fibo3 = fibo2;
			fibo2 = fibo1 - fibo2;
			fibo4 = fibo2 - fibo3;

			if (fibo1 > NormalizeDouble(div, 2))
			{
				break;
			}
		}

		if (profitOrLoss == 1)
		{
			if (fibo4 <= 0) {fibo4 = 1;}
			lots = initialLots * fibo4;
		}
		else
		{
			lots = initialLots * fibo1;
		}
	}

	lots = NormalizeDouble(lots, 2);

	return lots;
}

double BetLabouchere(
	string group,
	string symbol,
	int pool,
	double initialLots,
	string listOfNumbers,
	double reverse = false
) {
	double info[];
	GetBetTradesInfo(info, group, symbol, pool, false);

	double lots         = info[0];
	double profitOrLoss = info[1]; // 0 - unknown, 1 - profit, -1 - loss

	//-- Labouchere Logic
	static string memGroup[];
	static string memList[];
	static long memTicket[];

	int startAgain = false;

	//- get the list of numbers as it is stored in the memory, or store it
	int id = ArraySearch(memGroup, group);

	if (id == -1)
	{
		startAgain = true;

		if (listOfNumbers == "") {listOfNumbers = "1";}

		id = ArraySize(memGroup);

		ArrayResize(memGroup, id+1, id+1);
		ArrayResize(memList, id+1, id+1);
		ArrayResize(memTicket, id+1, id+1);

		memGroup[id] = group;
		memList[id]  = listOfNumbers;
	}

	if (memTicket[id] == (long)OrderTicket())
	{
		// the last known ticket (memTicket[id]) should be different than OderTicket() normally
		// when failed to create a new trade - the last ticket remains the same
		// so we need to reset
		memList[id] = listOfNumbers;
	}

	memTicket[id] = (long)OrderTicket();

	//- now turn the string into integer array
	int list[];
	string listS[];

	StringExplode(",", memList[id], listS);
	ArrayResize(list, ArraySize(listS));

	for (int s = 0; s < ArraySize(listS); s++)
	{
		list[s] = (int)StringToInteger(StringTrim(listS[s]));  
	}

	//-- 
	int size = ArraySize(list);

	double minLot = SymbolInfoDouble(symbol, SYMBOL_VOLUME_MIN);

	if (initialLots < minLot)
	{
		initialLots = minLot;  
	}

	if (lots == 0)
	{
		startAgain = true;
	}

	if (startAgain == true)
	{
		if (size == 1)
		{
			lots = initialLots * list[0];
		}
		else {
			lots = initialLots * (list[0] + list[size-1]);
		}
	}
	else 
	{
		if (
			   (reverse == 0 && profitOrLoss == 1)
			|| (reverse == 1 && profitOrLoss == -1)
		) {
			size = size - 2;
			
			if (size < 0) {
				size = 0;
			}
			
			if (size == 0) {
				// Set the initial list of numbers
				StringExplode(",", listOfNumbers, listS);
				ArrayResize(list, ArraySize(listS));
			
				for (int s = 0; s < ArraySize(listS); s++)
				{
					list[s] = (int)StringToInteger(StringTrim(listS[s]));  
				}
				
				size = ArraySize(list);
			}
			else {
				// Cancel the first and the last number in the list
				// shift array 1 step left
				for (int pos = 0; pos < ArraySize(list) - 1; pos++) {
					list[pos] = list[pos+1];
				}
				
				ArrayResize(list, size);
			}
			
			int rightNum = (size > 1) ? list[size - 1] : 0;
			lots = initialLots * (list[0] + rightNum);

			if (lots < initialLots) {lots = initialLots;}
		}
		else
		{
			size = size + 1;
			ArrayResize(list, size);
			
			int rightNum = (size > 2) ? list[size - 2] : 0;

			list[size - 1] = list[0] + rightNum;
			lots       = initialLots * (list[0] + list[size - 1]);

			if (lots < initialLots) {lots = initialLots;}
		}
	}

	Print("Labouchere (for group "
		+ (string)id
		+ ") current list of numbers: "
		+ StringImplode(",", list)
	);

	size=ArraySize(list);

	if (size == 0)
	{
		ArrayStripKey(memGroup, id);
		ArrayStripKey(memList, id);
		ArrayStripKey(memTicket, id);
	}
	else {
		memList[id] = StringImplode(",", list);
	}

	return lots;
}

double BetMartingale(
	string group,
	string symbol,
	int pool,
	double initialLots,
	double multiplyOnLoss,
	double multiplyOnProfit,
	double addOnLoss,
	double addOnProfit,
	int resetOnLoss,
	int resetOnProfit
) {
	double info[];
	GetBetTradesInfo(info, group, symbol, pool, true);

	double lots         = info[0];
	double profitOrLoss = info[1]; // 0 - unknown, 1 - profit, -1 - loss
	double consecutive  = info[2];

	//-- Martingale Logic
	if (lots == 0)
	{
		lots = initialLots;
	}
	else
	{
		if (profitOrLoss == 1)
		{
			if (resetOnProfit > 0 && consecutive >= resetOnProfit)
			{
				lots = initialLots;
			}
			else
			{
				if (multiplyOnProfit <= 0)
				{
					multiplyOnProfit = 1;
				}

				lots = (lots * multiplyOnProfit) + addOnProfit;
			}
		}
		else
		{
			if (resetOnLoss > 0 && consecutive >= resetOnLoss)
			{
				lots = initialLots;  
			}
			else
			{
				if (multiplyOnLoss <= 0)
				{
					multiplyOnLoss = 1;
				}

				lots = (lots * multiplyOnLoss) + addOnLoss;
			}
		}
	}

	return lots;
}

double BetSequence(
	string group,
	string symbol,
	int pool,
	double initialLots,
	string sequenceOnLoss,
	string sequenceOnProfit,
	bool reverse = false
) {  
	double info[];
	GetBetTradesInfo(info, group, symbol, pool, false);

	double lots         = info[0];
	double profitOrLoss = info[1]; // 0 - unknown, 1 - profit, -1 - loss

	//-- Sequence stuff
	static string memGroup[];
	static string memLossList[];
	static string memProfitList[];
	static long memTicket[];

	//- get the list of numbers as it is stored in the memory, or store it
	int id = ArraySearch(memGroup, group);

	if (id == -1)
	{
		if (sequenceOnLoss == "") {sequenceOnLoss = "1";}

		if (sequenceOnProfit == "") {sequenceOnProfit = "1";}

		id = ArraySize(memGroup);

		ArrayResize(memGroup, id+1, id+1);
		ArrayResize(memLossList, id+1, id+1);
		ArrayResize(memProfitList, id+1, id+1);
		ArrayResize(memTicket, id+1, id+1);

		memGroup[id]      = group;
		memLossList[id]   = sequenceOnLoss;
		memProfitList[id] = sequenceOnProfit;
	}

	bool lossReset   = false;
	bool profitReset = false;

	if (profitOrLoss == -1 && memLossList[id] == "")
	{
		lossReset         = true;
		memProfitList[id] = "";
	}

	if (profitOrLoss == 1 && memProfitList[id] == "")
	{
		profitReset     = true;
		memLossList[id] = "";
	}

	if (profitOrLoss == 1 || memLossList[id] == "")
	{
		memLossList[id] = sequenceOnLoss;

		if (lossReset) {
			memLossList[id] = "1," + memLossList[id];
		}
	}

	if (profitOrLoss == -1 || memProfitList[id] == "")
	{
		memProfitList[id] = sequenceOnProfit;

		if (profitReset) {
			memProfitList[id] = "1," + memProfitList[id];
		}
	}

	if (memTicket[id] == (long)OrderTicket())
	{
		// Normally the last known ticket (memTicket[id]) should be different than OderTicket()
		// when failed to create a new trade, the last ticket remains the same
		// so we need to reset
		memLossList[id]   = sequenceOnLoss;
		memProfitList[id] = sequenceOnProfit;
	}

	memTicket[id] = (long)OrderTicket();

	//- now turn the string into integer array
	int s = 0;
	double listLoss[];
	double listProfit[];
	string listS[];

	StringExplode(",", memLossList[id], listS);
	ArrayResize(listLoss, ArraySize(listS), ArraySize(listS));

	for (s = 0; s < ArraySize(listS); s++)
	{
		listLoss[s] = (double)StringToDouble(StringTrim(listS[s]));  
	}

	StringExplode(",", memProfitList[id], listS);
	ArrayResize(listProfit, ArraySize(listS), ArraySize(listS));

	for (s = 0; s < ArraySize(listS); s++)
	{
		listProfit[s] = (double)StringToDouble(StringTrim(listS[s]));  
	}

	//--
	double minLot = SymbolInfoDouble(symbol, SYMBOL_VOLUME_MIN);

	if (initialLots < minLot)
	{
		initialLots = minLot;  
	}

	if (lots == 0)
	{
		lots = initialLots;
	}
	else
	{
		if (
			   (reverse == false && profitOrLoss ==1)
			|| (reverse == true && profitOrLoss == -1)
		) {
			lots = initialLots * listProfit[0];

			// shift array 1 step left
			int size = ArraySize(listProfit);

			for(int pos = 0; pos < size-1; pos++)
			{
				listProfit[pos] = listProfit[pos+1];
			}

			if (size > 0)
			{
				ArrayResize(listProfit, size-1, size-1);
				memProfitList[id] = StringImplode(",", listProfit);
			}
		}
		else
		{
			lots = initialLots * listLoss[0];

			// shift array 1 step left
			int size = ArraySize(listLoss);

			for(int pos = 0; pos < size-1; pos++)
			{
				listLoss[pos] = listLoss[pos+1];
			}

			if (size > 0)
			{
				ArrayResize(listLoss, size-1, size-1);
				memLossList[id] = StringImplode(",", listLoss);
			}
		}
	}

	return lots;
}

long BuyLater(
	string symbol,
	double lots,
	double price,
	double sll = 0, // SL level
	double tpl = 0, // TP level
	double slp = 0, // SL adjust in points
	double tpp = 0, // TP adjust in points
	double slippage = 0,
	datetime expiration = 0,
	int magic = 0,
	string comment = "",
	color arrowcolor = clrNONE,
	bool oco = false
	)
{
	double ask = SymbolInfoDouble(symbol,SYMBOL_ASK);
	ENUM_ORDER_TYPE type = 0;

	     if (price == ask) {type = ORDER_TYPE_BUY;}
	else if (price < ask)  {type = ORDER_TYPE_BUY_LIMIT;}
	else if (price > ask)  {type = ORDER_TYPE_BUY_STOP;}

	return OrderCreate(
		symbol,
		type,
		lots,
		price,
		sll,
		tpl,
		slp,
		tpp,
		slippage,
		magic,
		comment,
		arrowcolor,
		expiration,
		oco
	);
}

long BuyNow(
	string symbol,
	double lots,
	double sll,
	double tpl,
	double slp,
	double tpp,
	double slippage = 0,
	int magic = 0,
	string comment = "",
	color arrowcolor = clrNONE,
	datetime expiration = 0
	)
{
	return OrderCreate(
		symbol,
		POSITION_TYPE_BUY,
		lots,
		0,
		sll,
		tpl,
		slp,
		tpp,
		slippage,
		magic,
		comment,
		arrowcolor,
		expiration
	);
}

int CheckForTradingError(int error_code=-1, string msg_prefix="")
{
   // return 0 -> no error
   // return 1 -> overcomable error
   // return 2 -> fatal error
   
   int retval=0;
   static int tryouts=0;
   
   //-- error check -----------------------------------------------------
   switch(error_code)
   {
      //-- no error
      case 0:
         retval=0;
         break;
      //-- overcomable errors
      case TRADE_RETCODE_REQUOTE:
      case TRADE_RETCODE_REJECT:
      case TRADE_RETCODE_ERROR:
      case TRADE_RETCODE_TIMEOUT:
      case TRADE_RETCODE_INVALID_VOLUME:
      case TRADE_RETCODE_INVALID_PRICE:
      case TRADE_RETCODE_INVALID_STOPS:
      case TRADE_RETCODE_INVALID_EXPIRATION:
      case TRADE_RETCODE_PRICE_CHANGED:
      case TRADE_RETCODE_PRICE_OFF:
      case TRADE_RETCODE_TOO_MANY_REQUESTS:
      case TRADE_RETCODE_NO_CHANGES:
      case TRADE_RETCODE_CONNECTION:
         retval=1;
         break;
      //-- critical errors
      default:
         retval=2;
         break;
   }
   
   if (error_code > 0)
   {
      string msg = "";
      if (retval == 1)
      {
         StringConcatenate(msg, msg_prefix,": ",ErrorMessage(error_code),". Retrying in 5 seconds..");
         Sleep(500); 
      }
      else if (retval == 2)
      {
         StringConcatenate(msg, msg_prefix,": ",ErrorMessage(error_code));
      }
      Print(msg);
   }
   
   if (retval==0)
   {
      tryouts=0;
   }
   else if (retval==1)
   {
      tryouts++;
      if (tryouts>=10)
      {
         tryouts=0;
         retval=2;
      }
      else
      {
         Print("retry #"+(string)tryouts+" of 10");
      }
   }
   
   return(retval);
}

bool CloseTrade(ulong ticket, ulong deviation = 0, color clr = clrNONE)
{
	while(true)
	{
		bool success = false;

		if (!PositionSelectByTicket(ticket))
		{
			return false;
		}

		string symbol = PositionGetString(POSITION_SYMBOL);
		long magic    = PositionGetInteger(POSITION_MAGIC);
		double volume = PositionGetDouble(POSITION_VOLUME);

		// With some CFD we can open position with the max volume more than once,
		// so we get a position that has volume bigger than the maximum.
		// Then we cannot close that position, because the volume is too high.
		// For that reason here we will close it in parts.
		double max_volume  = SymbolInfoDouble(symbol, SYMBOL_VOLUME_MAX);
		double part_volume = (volume > max_volume) ? max_volume : volume;

		//-- close --------------------------------------------------------
		MqlTradeRequest request;
		MqlTradeResult result;
		MqlTradeCheckResult check_result;
		ZeroMemory(request);
		ZeroMemory(result);
		ZeroMemory(check_result);

		if((ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
		{
			//--- prepare request for close BUY position
			request.type  = ORDER_TYPE_SELL;
			request.price = SymbolInfoDouble(symbol, SYMBOL_BID);
		}
		else
		{
			//--- prepare request for close SELL position
			request.type  = ORDER_TYPE_BUY;
			request.price = SymbolInfoDouble(symbol, SYMBOL_ASK);
		}

		request.action    = TRADE_ACTION_DEAL;
		request.symbol    = symbol;
		request.volume    = part_volume;
		request.magic     = magic;
		request.deviation = (int)(deviation * PipValue(symbol));

		// for hedging mode
		request.position  = ticket;

		// filling type
		if (IsFillingTypeAllowed(symbol, SYMBOL_FILLING_FOK))
			request.type_filling = ORDER_FILLING_FOK;
		else if (IsFillingTypeAllowed(symbol, SYMBOL_FILLING_IOC))
			request.type_filling = ORDER_FILLING_IOC;
		else if (IsFillingTypeAllowed(symbol, ORDER_FILLING_RETURN)) // just in case
			request.type_filling = ORDER_FILLING_RETURN;
		else
			request.type_filling = ORDER_FILLING_RETURN;

		success = OrderSend(request, result);

		//-- error check --------------------------------------------------
		if (!success || (result.retcode != TRADE_RETCODE_DONE && result.retcode != TRADE_RETCODE_PLACED && result.retcode != TRADE_RETCODE_DONE_PARTIAL))
		{
			string errmsgpfx = "Closing position/trade error";

			int erraction = CheckForTradingError(result.retcode, errmsgpfx);

			switch(erraction)
			{
				case 0: break;    // no error
				case 1: continue; // overcomable error
				case 2: break;    // fatal error
			}

			return false;
		}
		
		//-- finish work --------------------------------------------------
		if (result.retcode == TRADE_RETCODE_DONE || result.retcode == TRADE_RETCODE_PLACED)
		{
			// we are closing the position in parts?
			if (volume != part_volume)
			{
				continue; // continue the "while" loop, so that the whole volume could be closed
			}

			while (true)
			{
			  	if (MQLInfoInteger(MQL_TESTER) || !PositionSelectByTicket(ticket))
				{
					break;
				}

				Sleep(10);
			}
		}

		if (success == true)
		{
			if (USE_VIRTUAL_STOPS)
			{
				VirtualStopsDriver("clear", ticket);
			}

			expirationWorker.RemoveExpiration(ticket);
		}
		
		break;
	}
	
	OnTrade();

	return true;
}

bool CloseTradePartial(
	long   ticket,
	double volume,
	double deviation  = 0,
	color  arrowcolor = clrNONE // fake parameter
) {
	// When closing position with lot size bigger than the max lot size, the position is closed in parts.
	// This variable keeps the volume that remains to be closed.
	double volume_left_to_close = EMPTY_VALUE;
	
	while(true)
	{
		if (ticket != OrderTicket())
		{
			if (!PositionSelectByTicket(ticket))
			{
				Print("Cannot close a position: Position #", (string)ticket, " is already closed or it does not exist"); 
	
				return false;
			}
		}

		if (!PositionSelectByTicket(ticket))
		{
			return false;
		}

		string symbol           = PositionGetString(POSITION_SYMBOL);
		long magic              = PositionGetInteger(POSITION_MAGIC);
		double lotstep          = SymbolInfoDouble(symbol, SYMBOL_VOLUME_STEP);
		ENUM_POSITION_TYPE type = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);

		double old_sl     = attrStopLoss();
		double old_tp     = attrTakeProfit();
		double old_volume = OrderLots();

		if (volume > old_volume) {volume = old_volume;}

		// With some CFD we can open position with the max volume more than once,
		// so we get a position that has volume bigger than the maximum.
		// Then we cannot close that position, because the volume is too high.
		// For that reason here we will close it in parts.
		double max_volume  = SymbolInfoDouble(symbol, SYMBOL_VOLUME_MAX);

		volume = MathRound(volume / lotstep) * lotstep;
		volume = AlignLots(symbol, volume);
		
		double part_volume = 0;

		part_volume          = (volume > max_volume) ? max_volume : volume;
		part_volume          = AlignLots(symbol, part_volume);
		volume_left_to_close = (volume_left_to_close == EMPTY_VALUE) ? volume : volume_left_to_close - part_volume;

		if (volume_left_to_close <= 0) {break;} // stop the process if there is nothing left to be closed
		
		if (part_volume > volume_left_to_close) part_volume = volume_left_to_close;

		//-- close --------------------------------------------------------
		MqlTradeRequest request;
		MqlTradeResult result;
		MqlTradeCheckResult check_result;
		ZeroMemory(request);
		ZeroMemory(result);
		ZeroMemory(check_result);

		if((ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
		{
			//--- prepare request for close BUY position
			request.type  = ORDER_TYPE_SELL;
			request.price = SymbolInfoDouble(symbol, SYMBOL_BID);
		}
		else
		{
			//--- prepare request for close SELL position
			request.type  = ORDER_TYPE_BUY;
			request.price = SymbolInfoDouble(symbol, SYMBOL_ASK);
		}

		request.action    = TRADE_ACTION_DEAL;
		request.symbol    = symbol;
		request.volume    = part_volume;
		request.magic     = magic;
		request.deviation = (int)(deviation*PipValue(symbol));

		// for hedging mode
		request.position  = ticket;

		// filling type
		if (IsFillingTypeAllowed(symbol, SYMBOL_FILLING_FOK))
			request.type_filling = ORDER_FILLING_FOK;
		else if (IsFillingTypeAllowed(symbol, SYMBOL_FILLING_IOC))
			request.type_filling = ORDER_FILLING_IOC;
		else if (IsFillingTypeAllowed(symbol, ORDER_FILLING_RETURN)) // just in case
			request.type_filling = ORDER_FILLING_RETURN;

		int success = OrderSend(request, result);

		//-- error check --------------------------------------------------
		if (!success || (result.retcode != TRADE_RETCODE_DONE && result.retcode!=TRADE_RETCODE_PLACED && result.retcode != TRADE_RETCODE_DONE_PARTIAL))
		{
			string errmsgpfx = "New position error";

			int erraction = CheckForTradingError(result.retcode, errmsgpfx);

			switch(erraction)
			{
				case 0: break;    // no error
				case 1: continue; // overcomable error
				case 2: break;    // fatal error
			}

			return false;
		}

		//-- finish work --------------------------------------------------
		if (result.retcode == TRADE_RETCODE_DONE || result.retcode == TRADE_RETCODE_PLACED || result.retcode == TRADE_RETCODE_DONE_PARTIAL)
		{
			// we are closing the position in parts?
			if (volume != part_volume)
			{
				continue; // continue the "while" loop, so that the whole volume could be closed
			}

			while (true)
			{
				if (MQLInfoInteger(MQL_TESTER) || !PositionSelectByTicket(ticket) || (old_volume != NormalizeDouble(PositionGetDouble(POSITION_VOLUME), 5)))
				{
					break;
				}

			  	Sleep(10);
			}
		}

		if (USE_VIRTUAL_STOPS)
		{
			VirtualStopsDriver("clear",ticket);
		}

		if (volume != old_volume)
		{
			attrLotsClosed(volume);

			if (USE_VIRTUAL_STOPS)
			{
				VirtualStopsDriver("partial", ticket, old_sl, old_tp);
			}

			// In MQL5 it seems that when partially closing a position, the ticket number remains the same.
			// However, just in case we will extract the ticket number by using the the deal of the result.
			datetime expiration    = expirationWorker.GetExpiration(ticket);
			long positionID        = HistoryDealGetInteger(result.deal, DEAL_POSITION_ID);
			long positionNewTicket = 0;

			for (int i = 0; i < PositionsTotal(); i++)
			{
				if (PositionGetTicket(i) > 0)
				{
					if (PositionGetInteger(POSITION_IDENTIFIER) == positionID)
					{
						positionNewTicket = PositionGetInteger(POSITION_TICKET);
						break;
					}
				}
			}

			expirationWorker.RemoveExpiration(ticket);

			if (positionNewTicket > 0 && expiration > 0)
			{
				expirationWorker.SetExpiration(positionNewTicket, expiration);
			}
		}
		else
		{
			expirationWorker.RemoveExpiration(ticket);
		}

		break;
	}

	OnTrade();

	return true;
}

template<typename DT1, typename DT2>
bool CompareValues(string sign, DT1 v1, DT2 v2)
{
	     if (sign == ">") return(v1 > v2);
	else if (sign == "<") return(v1 < v2);
	else if (sign == ">=") return(v1 >= v2);
	else if (sign == "<=") return(v1 <= v2);
	else if (sign == "==") return(v1 == v2);
	else if (sign == "!=") return(v1 != v2);
	else if (sign == "x>") return(v1 > v2);
	else if (sign == "x<") return(v1 < v2);

	return false;
}

string CurrentSymbol(string symbol = "")
{
   static string memory = "";

	// Set
   if (symbol != "")
	{
		memory = symbol;
	}
	// Get
	else if (memory == "")
	{
		memory = Symbol();
	}

   return memory;
}

ENUM_TIMEFRAMES CurrentTimeframe(ENUM_TIMEFRAMES tf=-1)
{
   static ENUM_TIMEFRAMES memory=0;
   if (tf>=0) {memory=tf;}
   return(memory);
}

int CustomDigits(string symbol)
{
	double point = CustomPoint(symbol);
	
	if (point == 0)
	{
		return 0;
	}

	int digits = 0;

	while(true)
	{
		if (point >= 1) {break;}

		point = point * 10;
		digits++;
	}

	return digits;
}

double CustomPoint(string symbol)
{
	static string symbols[];
	static double points[];
	static string last_symbol = "-";
	static double last_point  = 0;
	static int last_i         = 0;
	static int size           = 0;

	//-- variant A) use the cache for the last used symbol
	if (symbol == last_symbol)
	{
		return last_point;
	}

	//-- variant B) search in the array cache
	int i			= last_i;
	int start_i	= i;
	bool found	= false;

	if (size > 0)
	{
		while (true)
		{
			if (symbols[i] == symbol)
			{
				last_symbol	= symbol;
				last_point	= points[i];
				last_i		= i;

				return last_point;
			}

			i++;

			if (i >= size)
			{
				i = 0;
			}
			if (i == start_i) {break;}
		}
	}

	//-- variant C) add this symbol to the cache
	i		= size;
	size	= size + 1;

	ArrayResize(symbols, size);
	ArrayResize(points, size);

	symbols[i]	= symbol;
	points[i]	= 0;
	last_symbol	= symbol;
	last_i		= i;

	//-- unserialize rules from FXD_POINT_FORMAT_RULES
	string rules[];
	StringExplode(",", POINT_FORMAT_RULES, rules);

	int rules_count = ArraySize(rules);

	if (rules_count > 0)
	{
		string rule[];

		for (int r = 0; r < rules_count; r++)
		{
			StringExplode("=", rules[r], rule);

			//-- a single rule must contain 2 parts, [0] from and [1] to
			if (ArraySize(rule) != 2) {continue;}

			double from = StringToDouble(rule[0]);
			double to	= StringToDouble(rule[1]);

			//-- "to" must be a positive number, different than 0
			if (to <= 0) {continue;}

			//-- "from" can be a number or a string
			// a) string
			if (from == 0 && StringLen(rule[0]) > 0)
			{
				string s_from = rule[0];
				int pos       = StringFind(s_from, "?");

				if (pos < 0) // ? not found
				{
					if (StringFind(symbol, s_from) == 0) {points[i] = to;}
				}
				else if (pos == 0) // ? is the first symbol => match the second symbol
				{
					if (StringFind(symbol, StringSubstr(s_from, 1), 3) == 3)
					{
						points[i] = to;
					}
				}
				else if (pos > 0) // ? is the second symbol => match the first symbol
				{
					if (StringFind(symbol, StringSubstr(s_from, 0, pos)) == 0)
					{
						points[i] = to;
					}
				}
			}

			// b) number
			if (from == 0) {continue;}

			if (SymbolInfoDouble(symbol, SYMBOL_POINT) == from)
			{
				points[i] = to;
			}
		}
	}

	if (points[i] == 0)
	{
		points[i] = SymbolInfoDouble(symbol, SYMBOL_POINT);
	}

	last_point = points[i];

	return last_point;
}

bool DeleteOrder(ulong ticket, color arrowcolor=clrNONE)
{
   while(true)
   {
      MqlTradeRequest request;
      MqlTradeResult result;
      MqlTradeCheckResult check_result;
      ZeroMemory(request);
      ZeroMemory(result);
      ZeroMemory(check_result);
   
      request.order=ticket;
      request.action=TRADE_ACTION_REMOVE;
      request.comment="Pending order canceled";
   
      if (!OrderCheck(request,check_result))  {
         Print("OrderCheck() failed: "+(string)check_result.comment+" ("+(string)check_result.retcode+")");
         return false;
      }
      
      bool success = OrderSend(request,result);
      
      //-- error check --------------------------------------------------
      if (!success || result.retcode!=TRADE_RETCODE_DONE)
      {
         string errmsgpfx="Delete order error";
         int erraction=CheckForTradingError(result.retcode, errmsgpfx);
         switch(erraction)
         {
            case 0: break;    // no error
            case 1: continue; // overcomable error
            case 2: break;    // fatal error
         }
         return(false);
      }
      
      //-- finish work --------------------------------------------------
      if (result.retcode==TRADE_RETCODE_DONE)
      {
         //== Wait until MT5 updates it's cache
         int w;
         for (w=0; w<5000; w++)
         {
            if (!OrderSelect(ticket)) {break;}
            Sleep(1);
         }
         if (w==5000) {
            Print("Check error: Delete order");  
         }
         if (OrderSelect(ticket)) {
            Print("Something went wrong with the order");
            return false;
         }
      }
		
		if (success==true) {
         if (USE_VIRTUAL_STOPS) {
            VirtualStopsDriver("clear",ticket);
         }
         //RegisterEvent("trade");
         //return(true);
      }
		
      break;
   }
   OnTrade();
   return(true);
}

string DoubleToStr(double d, int dig){return(DoubleToString(d,dig));}

void DrawSpreadInfo()
{
   static bool allow_draw = true;
   if (allow_draw==false) {return;}
   if (MQLInfoInteger(MQL_TESTER) && !MQLInfoInteger(MQL_VISUAL_MODE)) {allow_draw=false;} // Allowed to draw only once in testing mode

   static bool passed         = false;
   static double max_spread   = 0;
   static double min_spread   = EMPTY_VALUE;
   static double avg_spread   = 0;
   static double avg_add      = 0;
   static double avg_cnt      = 0;

   double custom_point = CustomPoint(Symbol());
   double current_spread = 0;
   if (custom_point > 0) {
      current_spread = (SymbolInfoDouble(Symbol(),SYMBOL_ASK)-SymbolInfoDouble(Symbol(),SYMBOL_BID))/custom_point;
   }
   if (current_spread > max_spread) {max_spread = current_spread;}
   if (current_spread < min_spread) {min_spread = current_spread;}
   
   avg_cnt++;
   avg_add     = avg_add + current_spread;
   avg_spread  = avg_add / avg_cnt;

   int x=0; int y=0;
   string name;

   // create objects
   if (passed == false)
   {
      passed=true;
      
      name="fxd_spread_current_label";
      if (ObjectFind(0, name)==-1) {
         ObjectCreate(0, name, OBJ_LABEL, 0, 0, 0);
         ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x+1);
         ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y+1);
         ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_LOWER);
         ObjectSetInteger(0, name, OBJPROP_ANCHOR, ANCHOR_LEFT_LOWER);
         ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
         ObjectSetInteger(0, name, OBJPROP_FONTSIZE, 18);
         ObjectSetInteger(0, name, OBJPROP_COLOR, clrDarkOrange);
         ObjectSetString(0, name, OBJPROP_FONT, "Arial");
         ObjectSetString(0, name, OBJPROP_TEXT, "Spread:");
      }
      name="fxd_spread_max_label";
      if (ObjectFind(0, name)==-1) {
         ObjectCreate(0, name, OBJ_LABEL, 0, 0, 0);
         ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x+148);
         ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y+17);
         ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_LOWER);
         ObjectSetInteger(0, name, OBJPROP_ANCHOR, ANCHOR_LEFT_LOWER);
         ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
         ObjectSetInteger(0, name, OBJPROP_FONTSIZE, 7);
         ObjectSetInteger(0, name, OBJPROP_COLOR, clrOrangeRed);
         ObjectSetString(0, name, OBJPROP_FONT, "Arial");
         ObjectSetString(0, name, OBJPROP_TEXT, "max:");
      }
      name="fxd_spread_avg_label";
      if (ObjectFind(0, name)==-1) {
         ObjectCreate(0, name, OBJ_LABEL, 0, 0, 0);
         ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x+148);
         ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y+9);
         ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_LOWER);
         ObjectSetInteger(0, name, OBJPROP_ANCHOR, ANCHOR_LEFT_LOWER);
         ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
         ObjectSetInteger(0, name, OBJPROP_FONTSIZE, 7);
         ObjectSetInteger(0, name, OBJPROP_COLOR, clrDarkOrange);
         ObjectSetString(0, name, OBJPROP_FONT, "Arial");
         ObjectSetString(0, name, OBJPROP_TEXT, "avg:");
      }
      name="fxd_spread_min_label";
      if (ObjectFind(0, name)==-1) {
         ObjectCreate(0, name, OBJ_LABEL, 0, 0, 0);
         ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x+148);
         ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y+1);
         ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_LOWER);
         ObjectSetInteger(0, name, OBJPROP_ANCHOR, ANCHOR_LEFT_LOWER);
         ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
         ObjectSetInteger(0, name, OBJPROP_FONTSIZE, 7);
         ObjectSetInteger(0, name, OBJPROP_COLOR, clrGold);
         ObjectSetString(0, name, OBJPROP_FONT, "Arial");
         ObjectSetString(0, name, OBJPROP_TEXT, "min:");
      }
      name="fxd_spread_current";
      if (ObjectFind(0, name)==-1) {
         ObjectCreate(0, name, OBJ_LABEL, 0, 0, 0);
         ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x+93);
         ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y+1);
         ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_LOWER);
         ObjectSetInteger(0, name, OBJPROP_ANCHOR, ANCHOR_LEFT_LOWER);
         ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
         ObjectSetInteger(0, name, OBJPROP_FONTSIZE, 18);
         ObjectSetInteger(0, name, OBJPROP_COLOR, clrDarkOrange);
         ObjectSetString(0, name, OBJPROP_FONT, "Arial");
         ObjectSetString(0, name, OBJPROP_TEXT, "0");
      }
      name="fxd_spread_max";
      if (ObjectFind(0, name)==-1) {
         ObjectCreate(0, name, OBJ_LABEL, 0, 0, 0);
         ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x+173);
         ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y+17);
         ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_LOWER);
         ObjectSetInteger(0, name, OBJPROP_ANCHOR, ANCHOR_LEFT_LOWER);
         ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
         ObjectSetInteger(0, name, OBJPROP_FONTSIZE, 7);
         ObjectSetInteger(0, name, OBJPROP_COLOR, clrOrangeRed);
         ObjectSetString(0, name, OBJPROP_FONT, "Arial");
         ObjectSetString(0, name, OBJPROP_TEXT, "0");
      }
      name="fxd_spread_avg";
      if (ObjectFind(0, name)==-1) {
         ObjectCreate(0, name, OBJ_LABEL, 0, 0, 0);
         ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x+173);
         ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y+9);
         ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_LOWER);
         ObjectSetInteger(0, name, OBJPROP_ANCHOR, ANCHOR_LEFT_LOWER);
         ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
         ObjectSetInteger(0, name, OBJPROP_FONTSIZE, 7);
         ObjectSetInteger(0, name, OBJPROP_COLOR, clrDarkOrange);
         ObjectSetString(0, name, OBJPROP_FONT, "Arial");
         ObjectSetString(0, name, OBJPROP_TEXT, "0");
      }
      name="fxd_spread_min";
      if (ObjectFind(0, name)==-1) {
         ObjectCreate(0, name, OBJ_LABEL, 0, 0, 0);
         ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x+173);
         ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y+1);
         ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_LOWER);
         ObjectSetInteger(0, name, OBJPROP_ANCHOR, ANCHOR_LEFT_LOWER);
         ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
         ObjectSetInteger(0, name, OBJPROP_FONTSIZE, 7);
         ObjectSetInteger(0, name, OBJPROP_COLOR, clrGold);
         ObjectSetString(0, name, OBJPROP_FONT, "Arial");
         ObjectSetString(0, name, OBJPROP_TEXT, "0");
      }
   }
   
   ObjectSetString(0, "fxd_spread_current", OBJPROP_TEXT, DoubleToStr(current_spread,2));
   ObjectSetString(0, "fxd_spread_max", OBJPROP_TEXT, DoubleToStr(max_spread,2));
   ObjectSetString(0, "fxd_spread_avg", OBJPROP_TEXT, DoubleToStr(avg_spread,2));
   ObjectSetString(0, "fxd_spread_min", OBJPROP_TEXT, DoubleToStr(min_spread,2));
}

string DrawStatus(string text="")
{
   static string memory;
   if (text=="") {
      return(memory);
   }
   
   static bool passed = false;
   int x=210; int y=0;
   string name;

   //-- draw the objects once
   if (passed == false)
   {
      passed = true;
      name="fxd_status_title";
      ObjectCreate(0,name, OBJ_LABEL, 0, 0, 0);
      ObjectSetInteger(0,name, OBJPROP_BACK, false);
      ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_LOWER);
      ObjectSetInteger(0, name, OBJPROP_ANCHOR, ANCHOR_LEFT_LOWER);
      ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
      ObjectSetInteger(0,name, OBJPROP_XDISTANCE, x);
      ObjectSetInteger(0,name, OBJPROP_YDISTANCE, y+17);
      ObjectSetString(0,name, OBJPROP_TEXT, "Status");
      ObjectSetString(0,name, OBJPROP_FONT, "Arial");
      ObjectSetInteger(0,name, OBJPROP_FONTSIZE, 7);
      ObjectSetInteger(0,name, OBJPROP_COLOR, clrGray);
      
      name="fxd_status_text";
      ObjectCreate(0,name, OBJ_LABEL, 0, 0, 0);
      ObjectSetInteger(0,name, OBJPROP_BACK, false);
      ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_LOWER);
      ObjectSetInteger(0, name, OBJPROP_ANCHOR, ANCHOR_LEFT_LOWER);
      ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
      ObjectSetInteger(0,name, OBJPROP_XDISTANCE, x+2);
      ObjectSetInteger(0,name, OBJPROP_YDISTANCE, y+1);
      ObjectSetString(0,name, OBJPROP_FONT, "Arial");
      ObjectSetInteger(0,name, OBJPROP_FONTSIZE, 12);
      ObjectSetInteger(0,name, OBJPROP_COLOR, clrAqua);
   }

   //-- update the text when needed
   if (text != memory) {
      memory=text;
      ObjectSetString(0,"fxd_status_text", OBJPROP_TEXT, text);
   }
   
   return(text);
}

double DynamicLots(string symbol, string mode="balance", double value=0, double sl=0, string align="align")
{
   double size=0;
   double LotStep=SymbolLotStep(symbol);
   double LotSize=SymbolLotSize(symbol);
   double MinLots=SymbolMinLot(symbol);
   double MaxLots=SymbolMaxLot(symbol);
   double TickValue=SymbolInfoDouble(symbol,SYMBOL_TRADE_TICK_VALUE);
   double margin_required=0;
   bool ocm = OrderCalcMargin(ORDER_TYPE_BUY,symbol,1,ask(symbol),margin_required); // This is the MODE_MARGINREQUIRED analog in MQL5
   //if (value>MaxLots) {value=value/LotSize;} // Money-to-Lot conversion
   
        if (mode=="fixed" || mode=="lots") {size=value;}
   else if (mode=="block-equity")     {size=(value/100)*AccountEquity()/margin_required;}
   else if (mode=="block-balance")    {size=(value/100)*AccountBalance()/margin_required;}
   else if (mode=="block-freemargin") {size=(value/100)*AccountFreeMargin()/margin_required;}
   else if (mode=="equity")     {size=(value/100)*AccountEquity()/(LotSize*TickValue);}
   else if (mode=="balance")    {size=(value/100)*AccountBalance()/(LotSize*TickValue);}
   else if (mode=="freemargin") {size=(value/100)*AccountFreeMargin()/(LotSize*TickValue);}
   else if (mode=="equityRisk") {size=((value/100)*AccountEquity())/(sl*TickValue*PipValue(symbol));}
   else if (mode=="safeMargin") {
            double SafeMargin = AccountEquity() * (Maximum_Margin_Percent / 100);
			   double xm = SafeMargin - AccountUsedMargin();
			   double um = AccountFreeMargin();
			   if(xm > AccountFreeMargin() )
			   {
			      um = AccountFreeMargin();
			   }else
			   {
			      um = xm;
			   }		
   size=((value/100)*um)/(sl*TickValue*PipValue(symbol));
   }
   else if (mode=="balanceRisk"){size=((value/100)*AccountBalance())/(sl*TickValue*PipValue(symbol));}
   else if (mode=="freemarginRisk") {size=((value/100)*AccountFreeMargin())/(sl*TickValue*PipValue(symbol));}
   else if (mode=="fixedRisk")   {size=(value)/(sl*TickValue*PipValue(symbol));}
   else if (mode=="fixedRatio" || mode=="RJFR") { 
      /////
      // Ryan Jones Fixed Ratio MM static data
      static double RJFR_start_lots=0;
      static double RJFR_delta=0;
      static double RJFR_units=1;
      static double RJFR_target_lower=0;
      static double RJFR_target_upper=0;
      /////
      
      if (RJFR_start_lots<=0) {RJFR_start_lots=value;}
      if (RJFR_start_lots<MinLots) {RJFR_start_lots=MinLots;}
      if (RJFR_delta<=0) {RJFR_delta=sl;}
      if (RJFR_target_upper<=0) {
         RJFR_target_upper=AccountEquity()+(RJFR_units*RJFR_delta);
         Print("Fixed Ratio MM: Units=>",RJFR_units,"; Delta=",RJFR_delta,"; Upper Target Equity=>",RJFR_target_upper);
      }
      if (AccountEquity()>=RJFR_target_upper)
      {
         while(true) {
            Print("Fixed Ratio MM going up to ",(RJFR_start_lots*(RJFR_units+1))," lots: Equity is above Upper Target Equity (",AccountEquity(),">=",RJFR_target_upper,")");
            RJFR_units++;
            RJFR_target_lower=RJFR_target_upper;
            RJFR_target_upper=RJFR_target_upper+(RJFR_units*RJFR_delta);
            Print("Fixed Ratio MM: Units=>",RJFR_units,"; Delta=",RJFR_delta,"; Lower Target Equity=>",RJFR_target_lower,"; Upper Target Equity=>",RJFR_target_upper);
            if (AccountEquity()<RJFR_target_upper) {break;}
         }
      }
      else if (AccountEquity()<=RJFR_target_lower)
      {
         while(true) {
         if (AccountEquity()>RJFR_target_lower) {break;}
            if (RJFR_units>1) {         
               Print("Fixed Ratio MM going down to ",(RJFR_start_lots*(RJFR_units-1))," lots: Equity is below Lower Target Equity | ", AccountEquity()," <= ",RJFR_target_lower,")");
               RJFR_target_upper=RJFR_target_lower;
               RJFR_target_lower=RJFR_target_lower-((RJFR_units-1)*RJFR_delta);
               RJFR_units--;
               Print("Fixed Ratio MM: Units=>",RJFR_units,"; Delta=",RJFR_delta,"; Lower Target Equity=>",RJFR_target_lower,"; Upper Target Equity=>",RJFR_target_upper);
            } else {break;}
         }
      }
      size=RJFR_start_lots*RJFR_units;
   }
		
	if (size==EMPTY_VALUE) {size=0;}
   
   static bool alert_min_lots=false;
   if (size<MinLots && alert_min_lots==false) {alert_min_lots=true;
      Alert("You want to trade ",size," lot, but your broker's minimum is ",MinLots," lot. The trade/order will continue with ",MinLots," lot instead of ",size," lot. The same rule will be applied for next trades/orders with desired lot size lower than the minimum. You will not see this message again until you restart the program.");
   }

   size=MathRound(size/LotStep)*LotStep;
   
   if (align=="align") {
      if (size<MinLots) {size=MinLots;}
      if (size>MaxLots) {size=MaxLots;}
   }
   
   return (size);
}

string ErrorMessage(int error_code=-1)
{
	string e = "";
	if (error_code<0) {error_code=GetLastError();}
	

	switch(error_code)
	{
		//--- success
		case 0: return("The operation completed successfully");
		
		//--- Runtime
		case 4001: e = "Unexpected internal error"; break;
		case 4002: e = "Wrong parameter in the inner call of the client terminal function"; break;
		case 4003: e = "Wrong parameter when calling the system function"; break;
		case 4004: e = "Not enough memory to perform the system function"; break;
		case 4005: e = "The structure contains objects of strings and/or dynamic arrays and/or structure of such objects and/or classes"; break;
		case 4006: e = "Array of a wrong type, wrong size, or a damaged object of a dynamic array"; break;
		case 4007: e = "Not enough memory for the relocation of an array, or an attempt to change the size of a static array"; break;
		case 4008: e = "Not enough memory for the relocation of string"; break;
		case 4009: e = "Not initialized string"; break;
		case 4010: e = "Invalid date and/or time"; break;
		case 4011: e = "Requested array size exceeds 2 GB"; break;
		case 4012: e = "Wrong pointer"; break;
		case 4013: e = "Wrong type of pointer"; break;
		case 4014: e = "System function is not allowed to call"; break;
		case 4015: e = "The names of the dynamic and the static resource match"; break;
		case 4016: e = "Resource with this name has not been found in EX5"; break;
		case 4017: e = "Unsupported resource type or its size exceeds 16 Mb"; break;
		case 4018: e = "The resource name exceeds 63 characters"; break;
		
		//-- Charts
		case 4101: e = "Wrong chart ID"; break;
		case 4102: e = "Chart does not respond"; break;
		case 4103: e = "Chart not found"; break;
		case 4104: e = "No Expert Advisor in the chart that could handle the event"; break;
		case 4105: e = "Chart opening error"; break;
		case 4106: e = "Failed to change chart symbol and period"; break;
		case 4107: e = "Wrong parameter for timer"; break;
		case 4108: e = "Failed to create timer"; break;
		case 4109: e = "Wrong chart property ID"; break;
		case 4110: e = "Error creating screenshots"; break;
		case 4111: e = "Error navigating through chart"; break;
		case 4112: e = "Error applying template"; break;
		case 4113: e = "Subwindow containing the indicator was not found"; break;
		case 4114: e = "Error adding an indicator to chart"; break;
		case 4115: e = "Error deleting an indicator from the chart"; break;
		case 4116: e = "Indicator not found on the specified chart"; break;

		//-- Graphical Objects
		case 4201: e = "Error working with a graphical object"; break;
		case 4202: e = "Graphical object was not found"; break;
		case 4203: e = "Wrong ID of a graphical object property"; break;
		case 4204: e = "Unable to get date corresponding to the value"; break;
		case 4205: e = "Unable to get value corresponding to the date"; break;

		//-- Market Info
		case 4301: e = "Unknown symbol"; break;
		case 4302: e = "Symbol is not selected in MarketWatch"; break;
		case 4303: e = "Wrong identifier of a symbol property"; break;
		case 4304: e = "Time of the last tick is not known (no ticks)"; break;
		case 4305: e = "Error adding or deleting a symbol in MarketWatch"; break;

		//-- History Access
		case 4401: e = "Requested history not found"; break;
		case 4402: e = "Wrong ID of the history property"; break;

		//-- Global Variables
		case 4501: e = "Global variable of the client terminal is not found"; break;
		case 4502: e = "Global variable of the client terminal with the same name already exists"; break;
		case 4510: e = "Email sending failed"; break;
		case 4511: e = "Sound playing failed"; break;
		case 4512: e = "Wrong identifier of the program property"; break;
		case 4513: e = "Wrong identifier of the terminal property"; break;
		case 4514: e = "File sending via ftp failed"; break;
		case 4515: e = "Failed to send a notification"; break;
		case 4516: e = "Invalid parameter for sending a notification - an empty string or NULL has been passed to the SendNotification() function"; break;
		case 4517: e = "Wrong settings of notifications in the terminal (ID is not specified or permission is not set)"; break;
		case 4518: e = "Too frequent sending of notifications"; break;

		//-- Custom Indicator Buffers
		case 4601: e = "Not enough memory for the distribution of indicator buffers"; break;
		case 4602: e = "Wrong indicator buffer index"; break;

		//-- Custom Indicator Properties
		case 4603: e = "Wrong ID of the custom indicator property"; break;

		//-- Account
		case 4701: e = "Wrong account property ID"; break;
		case 4751: e = "Wrong trade property ID"; break;
		case 4752: e = "Trading by Expert Advisors prohibited"; break;
		case 4753: e = "Position not found"; break;
		case 4754: e = "Order not found"; break;
		case 4755: e = "Deal not found"; break;
		case 4756: e = "Trade request sending failed"; break;

		//-- Indicators
		case 4801: e = "Unknown symbol"; break;
		case 4802: e = "Indicator cannot be created"; break;
		case 4803: e = "Not enough memory to add the indicator"; break;
		case 4804: e = "The indicator cannot be applied to another indicator"; break;
		case 4805: e = "Error applying an indicator to chart"; break;
		case 4806: e = "Requested data not found"; break;
		case 4807: e = "Wrong indicator handle"; break;
		case 4808: e = "Wrong number of parameters when creating an indicator"; break;
		case 4809: e = "No parameters when creating an indicator"; break;
		case 4810: e = "The first parameter in the array must be the name of the custom indicator"; break;
		case 4811: e = "Invalid parameter type in the array when creating an indicator"; break;
		case 4812: e = "Wrong index of the requested indicator buffer"; break;

		//-- Depth of Market
		case 4901: e = "Depth Of Market can not be added"; break;
		case 4902: e = "Depth Of Market can not be removed"; break;
		case 4903: e = "The data from Depth Of Market can not be obtained"; break;
		case 4904: e = "Error in subscribing to receive new data from Depth Of Market"; break;

		//-- File Operations
		case 5001: e = "More than 64 files cannot be opened at the same time"; break;
		case 5002: e = "Invalid file name"; break;
		case 5003: e = "Too long file name"; break;
		case 5004: e = "File opening error"; break;
		case 5005: e = "Not enough memory for cache to read"; break;
		case 5006: e = "File deleting error"; break;
		case 5007: e = "A file with this handle was closed, or was not opening at all"; break;
		case 5008: e = "Wrong file handle"; break;
		case 5009: e = "The file must be opened for writing"; break;
		case 5010: e = "The file must be opened for reading"; break;
		case 5011: e = "The file must be opened as a binary one"; break;
		case 5012: e = "The file must be opened as a text"; break;
		case 5013: e = "The file must be opened as a text or CSV"; break;
		case 5014: e = "The file must be opened as CSV"; break;
		case 5015: e = "File reading error"; break;
		case 5016: e = "String size must be specified, because the file is opened as binary"; break;
		case 5017: e = "A text file must be for string arrays, for other arrays - binary"; break;
		case 5018: e = "This is not a file, this is a directory"; break;
		case 5019: e = "File does not exist"; break;
		case 5020: e = "File can not be rewritten"; break;
		case 5021: e = "Wrong directory name"; break;
		case 5022: e = "Directory does not exist"; break;
		case 5023: e = "This is a file, not a directory"; break;
		case 5024: e = "The directory cannot be removed"; break;
		case 5025: e = "Failed to clear the directory (probably one or more files are blocked and removal operation failed)"; break;
		case 5026: e = "Failed to write a resource to a file"; break;

		//-- String Casting
		case 5030: e = "No date in the string"; break;
		case 5031: e = "Wrong date in the string"; break;
		case 5032: e = "Wrong time in the string"; break;
		case 5033: e = "Error converting string to date"; break;
		case 5034: e = "Not enough memory for the string"; break;
		case 5035: e = "The string length is less than expected"; break;
		case 5036: e = "Too large number, more than ULONG_MAX"; break;
		case 5037: e = "Invalid format string"; break;
		case 5038: e = "Amount of format specifiers more than the parameters"; break;
		case 5039: e = "Amount of parameters more than the format specifiers"; break;
		case 5040: e = "Damaged parameter of string type"; break;
		case 5041: e = "Position outside the string"; break;
		case 5042: e = "0 added to the string end, a useless operation"; break;
		case 5043: e = "Unknown data type when converting to a string"; break;
		case 5044: e = "Damaged string object"; break;

		//-- Operations with Arrays
		case 5050: e = "Copying incompatible arrays. String array can be copied only to a string array, and a numeric array - in numeric array only"; break;
		case 5051: e = "The receiving array is declared as AS_SERIES, and it is of insufficient size"; break;
		case 5052: e = "Too small array, the starting position is outside the array"; break;
		case 5053: e = "An array of zero length"; break;
		case 5054: e = "Must be a numeric array"; break;
		case 5055: e = "Must be a one-dimensional array"; break;
		case 5056: e = "Timeseries cannot be used"; break;
		case 5057: e = "Must be an array of type double"; break;
		case 5058: e = "Must be an array of type float"; break;
		case 5059: e = "Must be an array of type long"; break;
		case 5060: e = "Must be an array of type int"; break;
		case 5061: e = "Must be an array of type short"; break;
		case 5062: e = "Must be an array of type char"; break;
		
		//-- Operations with OpenCL
		case 5100: e = "OpenCL functions are not supported on this computer"; break;
		case 5101: e = "Internal error occurred when running OpenCL"; break;
		case 5102: e = "Invalid OpenCL handle"; break;
		case 5103: e = "Error creating the OpenCL context"; break;
		case 5104: e = "Failed to create a run queue in OpenCL"; break;
		case 5105: e = "Error occurred when compiling an OpenCL program"; break;
		case 5106: e = "Too long kernel name (OpenCL kernel)"; break;
		case 5107: e = "Error creating an OpenCL kernel"; break;
		case 5108: e = "Error occurred when setting parameters for the OpenCL kernel"; break;
		case 5109: e = "OpenCL program runtime error"; break;
		case 5110: e = "Invalid size of the OpenCL buffer"; break;
		case 5111: e = "Invalid offset in the OpenCL buffer"; break;
		case 5112: e = "Failed to create an OpenCL buffer"; break;
		
		//-- Operations with WebRequest
		case 5200: e = "Invalid URL"; break;
		case 5201: e = "Failed to connect to specified URL"; break;
		case 5202: e = "Timeout exceeded"; break;
		case 5203: e = "HTTP request failed"; break;

		//-- trading errors
		case 10004: e = "Requote occured"; break;
		case 10006: e = "Order is not accepted by the server"; break;
		case 10007: e = "Request canceled by trader"; break;
		case 10010: e = "Only part of the request was completed"; break;
		case 10011: e = "Request processing error"; break;
		case 10012: e = "Request canceled by timeout"; break;
		case 10013: e = "Invalid request"; break;
		case 10014: e = "Invalid volume"; break;
		case 10015: e = "Invalid price"; break;
		case 10016: e = "Invalid SL or TP"; break;
		case 10017: e = "Trading is disabled"; break;
		case 10018: e = "Market is closed"; break;
		case 10019: e = "Not enough money to trade"; break;
		case 10020: e = "Prices changed"; break;
		case 10021: e = "There are no quotes to process the request"; break;
		case 10022: e = "Invalid expiration date in the order request"; break;
		case 10023: e = "Order state changed"; break;
		case 10024: e = "Too frequent requests"; break;
		case 10025: e = "No changes in request"; break;
		case 10026: e = "Autotrading is disabled by the server"; break;
		case 10027: e = "Autotrading is disabled by the client terminal"; break;
		case 10028: e = "Request locked for processing"; break;
		case 10029: e = "Order or trade frozen"; break;
		case 10030: e = "Invalid order filling type"; break;
		case 10031: e = "No connection with the trade server"; break;
		case 10032: e = "Operation is allowed only for live accounts"; break;
		case 10033: e = "The number of pending orders has reached the limit"; break;
		case 10034: e = "The volume of orders and trades for the symbol has reached the limit"; break;
		case 10035: e = "Incorrect or prohibited order type"; break;
		case 10036: e = "Position with the specified POSITION_IDENTIFIER has already been closed"; break;
		case 10038: e = "A close volume exceeds the current position volume"; break;
		case 10039: e = "A close order already exists for a specified position"; break;
		//-- User-Defined Errors
		case 65536: e = "User defined errors"; break;
		default:	e = "Unknown error";
	}

	StringConcatenate(e, e," (",error_code,")");
	
	return e;
}

datetime ExpirationTime(string mode="GTC",int days=0, int hours=0, int minutes=0, datetime custom=0)
{
	datetime now        = TimeCurrent();
   datetime expiration = now;

	     if (mode == "GTC" || mode == "") {expiration = 0;}
	else if (mode == "today")             {expiration = (datetime)(MathFloor((now + 86400.0) / 86400.0) * 86400.0);}
	else if (mode == "specified")
	{
		expiration = 0;

		if ((days + hours + minutes) > 0)
		{
			expiration = now + (86400 * days) + (3600 * hours) + (60 * minutes);
		}
	}
	else
	{
		if (custom <= now)
		{
			if (custom < 31557600)
			{
				custom = now + custom;
			}
			else
			{
				custom = 0;
			}
		}

		expiration = custom;
	}

	return expiration;
}

ENUM_ORDER_TYPE_TIME ExpirationTypeByTime(string symbol, datetime expiration)
{
	datetime now                   = TimeCurrent();
	ENUM_ORDER_TYPE_TIME type_time = ORDER_TIME_GTC;

	// Detect Type Time
	if (expiration == 0 || expiration <= now)
	{
		type_time = ORDER_TIME_GTC;
	}
	else if (expiration == (datetime)(MathFloor((now + 86400.0) / 86400.0) * 86400.0))
	{
		type_time = ORDER_TIME_DAY;
	}
	else
	{
		type_time = ORDER_TIME_SPECIFIED;
	}

	// What if certain Type Time is not allowed?
	if (type_time == ORDER_TIME_GTC && !IsExpirationTypeAllowed(symbol, SYMBOL_EXPIRATION_GTC))
	{
		type_time = ORDER_TIME_DAY;
	}
	
	if (type_time == ORDER_TIME_DAY && !IsExpirationTypeAllowed(symbol, SYMBOL_EXPIRATION_DAY))
	{
		type_time = ORDER_TIME_SPECIFIED;
	}

	// Return Type Time
	return type_time;
}

class ExpirationWorker
{
private:
	struct CachedItems
	{
		long ticket;
		datetime expiration;
	};

	CachedItems cachedItems[];
	long chartID;
	string chartObjectPrefix;
	string chartObjectSuffix;

	template<typename T>
	void ArrayClone(T &dest[], T &src[])
	{
		int size = ArraySize(src);
		ArrayResize(dest, size);

		for (int i = 0; i < size; i++)
		{
			dest[i] = src[i];
		}
	}

	void InitialDiscovery()
	{
		ArrayResize(cachedItems, 0);

		int total = PositionsTotal();

		for (int index = 0; index <= total; index++)
		{
			long ticket = GetTicketByIndex(index);

			if (ticket == 0) continue;

			datetime expiration = GetExpirationFromObject(ticket);

			if (expiration > 0)
			{
				SetExpirationInCache(ticket, expiration);
			}
		}
	}

	long GetTicketByIndex(int index)
	{
		return (long)PositionGetTicket(index);
	}

	datetime GetExpirationFromObject(long ticket)
	{
		datetime expiration = (datetime)0;
		
		string objectName = chartObjectPrefix + IntegerToString(ticket) + chartObjectSuffix;

		if (ObjectFind(chartID, objectName) == chartID)
		{
			expiration = (datetime)ObjectGetInteger(chartID, objectName, OBJPROP_TIME);
		}

		return expiration;
	}

	bool RemoveExpirationObject(long ticket)
	{
		bool success      = false;
		string objectName = "";

		objectName = chartObjectPrefix + IntegerToString(ticket) + chartObjectSuffix;
		success    = ObjectDelete(chartID, objectName);

		return success;
	}

	void RemoveExpirationFromCache(long ticket)
	{
		int size = ArraySize(cachedItems);
		CachedItems newItems[];
		int newSize = 0;
		bool itemRemoved = false;

		for (int i = 0; i < size; i++)
		{
			if (cachedItems[i].ticket == ticket)
			{
				itemRemoved = true;
			}
			else
			{
				newSize++;
				ArrayResize(newItems, newSize);
				newItems[newSize - 1].ticket     = cachedItems[i].ticket;
				newItems[newSize - 1].expiration = cachedItems[i].expiration;
			}
		}

		if (itemRemoved) ArrayClone(cachedItems, newItems);
	}

	void SetExpirationInCache(long ticket, datetime expiration)
	{
		bool alreadyExists = false;
		int size           = ArraySize(cachedItems);

		for (int i = 0; i < size; i++)
		{
			if (cachedItems[i].ticket == ticket)
			{
				cachedItems[i].expiration = expiration;
				alreadyExists = true;
				break;
			}
		}

		if (alreadyExists == false)
		{
			ArrayResize(cachedItems, size + 1);
			cachedItems[size].ticket     = ticket;
			cachedItems[size].expiration = expiration;
		}
	}

	bool SetExpirationInObject(long ticket, datetime expiration)
	{
		if (!PositionSelectByTicket(ticket)) return false;

		string objectName = chartObjectPrefix + IntegerToString(ticket) + chartObjectSuffix;
		double price      = OrderOpenPrice();

		if (ObjectFind(chartID, objectName) == chartID)
		{
			ObjectSetInteger(chartID, objectName, OBJPROP_TIME, expiration);
			ObjectSetDouble(chartID, objectName, OBJPROP_PRICE, price);
		}
		else
		{
			ObjectCreate(chartID, objectName, OBJ_ARROW, 0, expiration, price);
		}

		ObjectSetInteger(chartID, objectName, OBJPROP_ARROWCODE, 77);
		ObjectSetInteger(chartID, objectName, OBJPROP_HIDDEN, true);
		ObjectSetInteger(chartID, objectName, OBJPROP_ANCHOR, ANCHOR_TOP);
		ObjectSetInteger(chartID, objectName, OBJPROP_COLOR, clrRed);
		ObjectSetInteger(chartID, objectName, OBJPROP_SELECTABLE, false);
		ObjectSetInteger(chartID, objectName, OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
		ObjectSetString(chartID, objectName, OBJPROP_TEXT, TimeToString(expiration));

		return true;
	}
	
	bool TradeExists(long ticket)
	{
		bool exists  = false;

		for (int i = 0; i < PositionsTotal(); i++)
		{
			long positionTicket = (long)PositionGetTicket(i);

			if (!positionTicket) continue;

			if (positionTicket == ticket)
			{
				exists = true;
				break;
			}
		}

		return exists;
	}

public:
	// Default constructor
	ExpirationWorker()
	{
		chartID           = 0;
		chartObjectPrefix = "#";
		chartObjectSuffix = " Expiration Marker";

		InitialDiscovery();
	}

	void SetExpiration(long ticket, datetime expiration)
	{
		if (expiration <= 0)
		{
			RemoveExpiration(ticket);
		}
		else
		{
			SetExpirationInObject(ticket, expiration);
			SetExpirationInCache(ticket, expiration);
		}
	}

	datetime GetExpiration(long ticket)
	{
		datetime expiration = (datetime)0;
		int size            = ArraySize(cachedItems);

		for (int i = 0; i < size; i++)
		{
			if (cachedItems[i].ticket == ticket)
			{
				expiration = cachedItems[i].expiration;
				break;
			}
		}

		return expiration;
	}

	void RemoveExpiration(long ticket)
	{
		RemoveExpirationObject(ticket);
		RemoveExpirationFromCache(ticket);
	}

	void Run()
	{
		int count = ArraySize(cachedItems);

		if (count > 0)
		{
			datetime timeNow = TimeCurrent();

			for (int i = 0; i < count; i++)
			{
				if (timeNow >= cachedItems[i].expiration)
				{
					long ticket           = cachedItems[i].ticket;
					bool removeExpiration = false;

					if (TradeExists(ticket))
					{
						if (CloseTrade(ticket))
						{
							Print("close #", ticket, " by expiration");
							removeExpiration = true;
						}
					}
					else
					{
						removeExpiration = true;
					}

					if (removeExpiration)
					{
						RemoveExpiration(ticket);

						// Removing expiration causes change in the size of the cache,
						// so reset of the size and one step back of the index is needed
						count = ArraySize(cachedItems);
						i--;
					}
				}
			}
		}
	}
};

ExpirationWorker expirationWorker;

bool FilterEventTrade(string group_mode,string group,string market_mode="market",string market="",string BuysOrSells="both", string LimitsOrStops="")
{
	int TradesOrders = (LimitsOrStops == "") ? 0 : 1;

	return FilterOrderBy(group_mode, group, market_mode, market, BuysOrSells, LimitsOrStops, TradesOrders, true);
}

bool FilterOrderBy(
	string group_mode    = "all",
	string group         = "0",
	string market_mode   = "all",
	string market        = "",
	string BuysOrSells   = "both",
	string LimitsOrStops = "",
	int unused           = 0, // for MQL4 compatibility
	bool onTrade         = false
) {
	//-- db
	static string markets[];
	static string market0	= "-";
	static int markets_size = 0;
	
	static string groups[];
	static string group0	  = "-";
	static int groups_size = 0;
	
	//-- local variables
	bool type_pass	  = false;
	bool market_pass = false;
	bool group_pass  = false;

	int i;
	long type;
	ulong magic_number;
	string symbol;
	
	// Trades
	if (onTrade == false)
	{
		type         = OrderType();
		magic_number = OrderMagicNumber();
		symbol       = OrderSymbol();
	}
	else
	{
		type         = e_attrType();
		magic_number = e_attrMagicNumber();
		symbol       = e_attrSymbol();
	}
	
	// Trades && History trades
	if (LimitsOrStops == "")
	{
		if (
				(BuysOrSells == "both"  && (type == ORDER_TYPE_BUY || type == ORDER_TYPE_SELL))
			|| (BuysOrSells == "buys"  && type == ORDER_TYPE_BUY)
			|| (BuysOrSells == "sells" && type == ORDER_TYPE_SELL)
			)
		{
			type_pass = true;
		}
	}
	// Pending orders
	else
	{
		if (
				(BuysOrSells == "both" && (type == ORDER_TYPE_BUY_LIMIT || type == ORDER_TYPE_BUY_STOP || type == ORDER_TYPE_SELL_LIMIT || type == ORDER_TYPE_SELL_STOP))
			||	(BuysOrSells == "buys" && (type == ORDER_TYPE_BUY_LIMIT || type == ORDER_TYPE_BUY_STOP))
			|| (BuysOrSells == "sells" && (type == ORDER_TYPE_SELL_LIMIT || type == ORDER_TYPE_SELL_STOP))
			)
		{
			if (
					(LimitsOrStops == "both" && (type == ORDER_TYPE_BUY_STOP || type == ORDER_TYPE_SELL_STOP || type == ORDER_TYPE_BUY_LIMIT || type == ORDER_TYPE_SELL_LIMIT))
				||	(LimitsOrStops == "stops" && (type == ORDER_TYPE_BUY_STOP || type == ORDER_TYPE_SELL_STOP))
				|| (LimitsOrStops == "limits" && (type == ORDER_TYPE_BUY_LIMIT || type == ORDER_TYPE_SELL_LIMIT))	
				)
			{
				type_pass = true;
			}
		}
	}
	if (type_pass == false) {return false;}
	
	//-- check group
	if (group_mode == "group")
	{
		if (group == "")
		{
			if (magic_number == MagicStart)
			{
				group_pass = true;
			}
		}
		else
		{
			if (group0 != group)
			{
				group0 = group;
				StringExplode(",", group, groups);
				groups_size = ArraySize(groups);

				for(i = 0; i < groups_size; i++)
				{
					groups[i] = StringTrim(groups[i]);

					if (groups[i] == "")
					{
						groups[i] = "0";
					}
				}
			}

			for(i = 0; i < groups_size; i++)
			{
				if (magic_number == (MagicStart + (int)groups[i]))
				{
					group_pass = true;

					break;
				}
			}
		}
	}
	else if (group_mode == "all" || (group_mode == "manual" && magic_number == 0))
	{
		group_pass = true;  
	}

	if (group_pass == false) {return false;}
	
	// check market
	if (market_mode == "all")
	{
		market_pass = true;
	}
	else
	{
		if (symbol == market)
		{
			market_pass = true;
		}
		else
		{
			if (market0 != market)
			{
				market0 = market;

				if (market == "")
				{
					markets_size = 1;
					ArrayResize(markets,1);
					markets[0] = Symbol();
				}
				else
				{
					StringExplode(",", market, markets);
					markets_size = ArraySize(markets);

					for(i = 0; i < markets_size; i++)
					{
						markets[i] = StringTrim(markets[i]);

						if (markets[i] == "")
						{
							markets[i] = Symbol();
						}
					}
				}
			}

			for(i = 0; i < markets_size; i++)
			{
				if (symbol == markets[i])
				{
					market_pass = true;

					break;
				}
			}
		}
	}

	if (market_pass == false) {return false;}
 
	return(true);
}

void GetBetTradesInfo(
	double &output[],
	string group,
	string symbol,
	int pool, // 0: try running trades first and then history trades, 1: try running only, 2: try history only
	bool findConsecutive = false
) {
	if (ArraySize(output) < 4)
	{
		ArrayResize(output, 4);
		ArrayInitialize(output, 0.0);
	}

	double lots         = output[0]; // will be the lot size of the first loaded trade
	double profitOrLoss = output[1]; // 0 is initial value, 1 is profit, -1 is loss
	double consecutive  = output[2]; // the number of consecutive profitable or losable trades
	double profit       = output[3]; // will be the profit of the first loaded trade
	bool historyTrades  = (pool == 2) ? true : false;
	
	int total = (historyTrades) ? HistoryTradesTotal() : TradesTotal();

	for (int pos = total - 1; pos >= 0; pos--)
	{
		if (
			   (!historyTrades && TradeSelectByIndex(pos, "group", group, "symbol", symbol))
			|| (historyTrades && HistoryTradeSelectByIndex(pos, "group", group, "symbol", symbol))
		) {
			if (
				((pool == 0 || pool == 1) && TimeCurrent() - OrderOpenTime() < 3) // skip for brand new trades
				||
				(
					// exclude expired pending orders
					!historyTrades
					&& OrderExpiration() > 0
					&& OrderExpiration() <= OrderCloseTime()
				)
			) {
				continue;
			}

			if (lots == 0.0)
			{
				lots = OrderLots();
			}

			profit = OrderClosePrice() - OrderOpenPrice();
			profit = NormalizeDouble(profit, SymbolDigits(OrderSymbol()));
			
			if (profit == 0.0)
			{
				// Consider a trade with zero profit as non existent
				continue;
			}

			if (IsOrderTypeSell())
			{
				profit = -1 * profit;
			}

			if (profitOrLoss == 0)
			{
				// We enter here only for the first trade
				profitOrLoss = (profit < 0.0) ? -1 : 1;

				consecutive++;

				if (findConsecutive == false) break;
			}
			else
			{
				// For the trades after the first one, if its profit is the opposite of profitOrLoss, we need to break
				if (
					   (profitOrLoss > 0.0 && profit < 0.0)
					|| (profitOrLoss < 0.0 && profit > 0.0)
				) {
					break;
				}

				consecutive++;
			}
		}
	}

	output[0] = lots;
	output[1] = profitOrLoss;
	output[2] = consecutive;
	output[3] = profit;
	
	if (pool == 0 && (findConsecutive || profitOrLoss == 0))
	{
		// running trades tried, continue with the history trades
		pool = 2;
		GetBetTradesInfo(output, group, symbol, pool, findConsecutive);
	}
}

bool GetFlagB(string flagname)
{
   return(SetFlagB(flagname,false,"get"));
}

string GetFlagT(string flagname)
{
   return(SetFlagT(flagname,"","get"));
}

double HighestFromTo(string symbol, ENUM_TIMEFRAMES timeframe, datetime time1, datetime time2, int what_to_get=0)
{
	static datetime HighestTime = 0;
	static double HighestID     = 0.0;

	double retval     = 0.0;
	double HighestVal = 0;

	if (HighestTime == 0) {HighestTime = TimeCurrent();}

	//-- Time mode ---------------------------------------------------------------------
	if (time1 > 1000000)
	{
		double CandleHigh = 0.0;
		int x1            = iBarShift(symbol, timeframe, time1, false);
		int x2            = iBarShift(symbol, timeframe, time2, false);

		if (x1 < x2)
		{
			x1 = iBarShift(symbol, timeframe, (time1 - 86400), false);
		}

		if (x1 < 0 || x2 < 0)
		{
			return -1;
		}

		for (int i = x2; i <= x1; i++)
		{
			CandleHigh = iHigh(symbol, timeframe, i);

			if (CandleHigh > HighestVal)
			{
				HighestVal  = CandleHigh;
				HighestTime = iTime(symbol, timeframe, i);
				HighestID   = i;
			}
		}
	}
	//-- Bars mode ---------------------------------------------------------------------
	else
	{
		int shift = 0;

		if (time1 == time2)
		{
			shift = (int)time1;
		}
		else
		{
			int totalbars = iBars(symbol, timeframe) - 1;

			if (time2 > totalbars || time2 == 0)
			{
				time2 = totalbars;
			}

			shift = iHighest(symbol, timeframe, MODE_HIGH, (int)(time2-time1)+1, (int)time1);
		}

		HighestVal  = iHigh(symbol, timeframe, shift);
		HighestTime = iTime(symbol, timeframe, shift);
		HighestID   = shift;
	}

	retval = HighestVal;

	if (what_to_get == 2)
	{
		retval = (double)HighestTime;
	}
	else if (what_to_get == 0)
	{
		retval = HighestID;
	}

	retval = NormalizeDouble(retval, (int)SymbolInfoInteger(symbol, SYMBOL_DIGITS));

	return retval;
}

bool HistoryTradeSelectByIndex(
	int index,
	string group_mode    = "all",
	string group         = "0",
	string market_mode   = "all",
	string market        = "",
	string BuysOrSells   = "both"
) {
	if (LoadHistoryTrade(index, "select_by_pos") && LoadedType() == 3)
	{
		if (FilterOrderBy(
			group_mode,
			group,
			market_mode,
			market,
			BuysOrSells)
		) {
			return true;
		}
	}

	return false;
}

int HistoryTradesTotal(datetime from_date=0, datetime to_date=0)
{
	if (to_date == 0) {to_date = TimeCurrent() + 1;}
	
	HistorySelect(from_date, to_date);
	
	SelectedHistoryFromTime(from_date);
	SelectedHistoryToTime(to_date);
	
	return HistoryDealsTotal();
}

void HistoryTradesTotalReset()
{
	if (SelectedHistoryToTime() > 0 || SelectedHistoryFromTime() > 0) {
		HistorySelect(SelectedHistoryFromTime(), SelectedHistoryToTime());
	}
}

template<typename T>
bool InArray(T &array[], T value)
{
	int size = ArraySize(array);

	if (size > 0)
	{
		for (int i = 0; i < size; i++)
		{
			if (array[i] == value)
			{
				return true;
			}
		}
	}

	return false;
}

//+------------------------------------------------------------------+
//| Checks if the specified expiration mode is allowed               |
//+------------------------------------------------------------------+
bool IsExpirationTypeAllowed(string symbol,int exp_type)
  {
//--- Obtain the value of the property that describes allowed expiration modes
   int expiration=(int)SymbolInfoInteger(symbol,SYMBOL_EXPIRATION_MODE);
//--- Return true, if mode exp_type is allowed
   return((expiration&exp_type)==exp_type);
  }

bool IsFillingTypeAllowed(string symbol,int fill_type)
{
//--- Obtain the value of the property that describes allowed filling modes
   int filling=(int)SymbolInfoInteger(symbol,SYMBOL_FILLING_MODE);
//--- Return true, if mode fill_type is allowed
   return((filling & fill_type)==fill_type);
}

bool IsOrderTypeBuy()
{
	int loadedType = LoadedType();

	if (loadedType == 1)
	{
		if (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
		{
			return true;
		}
	}
	else if (loadedType == 3)
	{
		return (OrderType() == ORDER_TYPE_BUY);
	}
	else if (loadedType == 4)
	{
		ulong orderTicket = OrderTicket();

		if (
			HistoryOrderSelect(orderTicket)
			&& (
				HistoryOrderGetInteger(orderTicket, ORDER_TYPE) == ORDER_TYPE_BUY_LIMIT
				|| HistoryOrderGetInteger(orderTicket, ORDER_TYPE) == ORDER_TYPE_BUY_STOP
			)
		) {
			return true;
		}
	}
	else if (
		OrderGetInteger(ORDER_TYPE) == ORDER_TYPE_BUY_LIMIT
		|| OrderGetInteger(ORDER_TYPE) == ORDER_TYPE_BUY_STOP
	) {
		return true;
	}

	return false;
}

bool IsOrderTypeSell()
{
	int loadedType = LoadedType();

	if (loadedType == 1)
	{
		if (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL)
		{
			return true;
		}
	}
	else if (loadedType == 3)
	{
		return (OrderType() == ORDER_TYPE_SELL);
	}
	else if (loadedType == 4)
	{
		ulong orderTicket = OrderTicket();
		
		if (
			HistoryOrderSelect(orderTicket)
			&& (
				HistoryOrderGetInteger(orderTicket, ORDER_TYPE) == ORDER_TYPE_SELL_LIMIT
				|| HistoryOrderGetInteger(orderTicket, ORDER_TYPE) == ORDER_TYPE_SELL_STOP
			)
		) {
			return true;
		}
	}
	else if (
		OrderGetInteger(ORDER_TYPE) == ORDER_TYPE_SELL_LIMIT
		|| OrderGetInteger(ORDER_TYPE) == ORDER_TYPE_SELL_STOP
	) {
		return true;
	}

	return false;
}

bool IsOrderTypeStop() {
	int loadedType = LoadedType();

   if (loadedType == 2) {
      if (
         OrderGetInteger(ORDER_TYPE) == ORDER_TYPE_BUY_STOP
         ||
         OrderGetInteger(ORDER_TYPE) == ORDER_TYPE_SELL_STOP
      ) {
      	return true;
      }
   }
   if (loadedType == 4) {
   	ulong orderTicket = OrderTicket();
   	
      if (
      	HistoryOrderSelect(orderTicket)
      	&& (
		      HistoryOrderGetInteger(orderTicket, ORDER_TYPE) == ORDER_TYPE_BUY_STOP
		      || HistoryOrderGetInteger(orderTicket, ORDER_TYPE) == ORDER_TYPE_SELL_STOP
		   )
      ) {
      	return true;
     	}
   }

   return false;
}

bool LoadHistoryOrder(int index, string selectby="select_by_pos")
{
	if (selectby == "select_by_pos")
	{
		ulong ticket  = HistoryOrderGetTicket(index);

		if (ticket > 0)
		{
			if (
				   HistoryOrderGetInteger(ticket, ORDER_TYPE) >= 2
				&& HistoryOrderSelect(ticket))
			{
				OrderTicket(ticket);

				LoadedType(4);

				return true;
			}
			else if (
				   HistoryOrderGetInteger(ticket, ORDER_TYPE) < 2
				&& HistoryOrderSelect(HistoryDealGetInteger(ticket, DEAL_POSITION_ID))
				&& (ENUM_DEAL_ENTRY)HistoryDealGetInteger(ticket, DEAL_ENTRY) == DEAL_ENTRY_OUT
				)
			{
				OrderTicket(ticket);

				LoadedType(3);

				return true;
			}
		}
	}

	if (selectby == "select_by_ticket")
	{
		if (HistoryOrderSelect(index))
		{
			HistoryDealSelect(index); // Select deal, it will be just one with pos=0
			HistoryDealGetTicket(0); // Load the one and only selected deal

			OrderTicket(index);

			if (HistoryOrderGetInteger(index, ORDER_TYPE) >= 2)
			{
				LoadedType(4);

				return true;
			}
			else
			{
				LoadedType(3);

				return true;
			}
		}
	}

	return false;
}

bool LoadHistoryTrade(int index, string selectby="select_by_pos")
{
	if (selectby == "select_by_pos")
	{
		ulong ticket  = HistoryDealGetTicket(index);

		if (ticket > 0)
		{
			if (
				   //HistoryDealSelect(ticket) - commented, because it breaks HistorySelect()
				   HistoryDealGetInteger(ticket, DEAL_TYPE) < 2
				&& (ENUM_DEAL_ENTRY)HistoryDealGetInteger(ticket, DEAL_ENTRY) == DEAL_ENTRY_OUT
				)
			{
				OrderTicket(ticket);

				LoadedType(3);

				return true;
			}
		}
	}

	if (selectby == "select_by_ticket")
	{
		if (HistoryDealSelect(index))
		{
			OrderTicket(index);

			if (HistoryDealGetInteger(index, DEAL_TYPE) < 2)
			{
				LoadedType(3);

				return true;
			}
		}
	}

	return false;
}

bool LoadPendingOrder(long ticket)
{
	bool success = false;

   if (OrderSelect(ticket))
	{
		// The order could be from any type, so check the type
		// and allow only true pending orders.
		ENUM_ORDER_TYPE type = (ENUM_ORDER_TYPE)OrderGetInteger(ORDER_TYPE);

		if (
			   type == ORDER_TYPE_BUY_LIMIT
			|| type == ORDER_TYPE_SELL_LIMIT
			|| type == ORDER_TYPE_BUY_STOP
			|| type == ORDER_TYPE_SELL_STOP
		) {
			LoadedType(2);
			OrderTicket(ticket);
			success = true;
		}
	}

   return success;
}

bool LoadPosition(ulong ticket)
{
   bool success = PositionSelectByTicket(ticket);

   if (success) {
		LoadedType(1);
		OrderTicket(ticket);
	}

   return success;
}

string LoadedObjectName(string name = "")
{
	static string memory = "";

	if (name != "") {memory = name;}

	return memory;
}

int LoadedType(int type = 0)
{
	// 1 - position
	// 2 - pending order
	// 3 - history position
	// 4 - history pending order

	static int memory;

	if (type > 0) {memory = type;}

	return memory;
}

bool LoopedResume()
{
	long ticket = attrTicketInLoop();
	int type    = attrTypeInLoop();

	if (ticket > 0 && ticket != OrderTicket()) {
		     if (type == 1) return LoadPosition(ticket);
		else if (type == 2) return LoadPendingOrder(ticket);
		else if (type == 3) return LoadHistoryOrder((int)ticket, "select_by_ticket");
	}

	return false;
}

double LowestFromTo(string symbol, ENUM_TIMEFRAMES timeframe, datetime time1, datetime time2, int what_to_get=0)
{
	static datetime LowestTime = 0;
	static double LowestID     = 0.0;

	double retval    = 0.0;
	double LowestVal = 0.0;

	if (LowestTime == 0) {LowestTime = TimeCurrent();}

	//-- Time mode ---------------------------------------------------------------------
	if (time1 > 1000000)
	{
		double CandleLow = 0.0;
		int x1           = iBarShift(symbol, timeframe, time1, false);
		int x2           = iBarShift(symbol, timeframe, time2, false);

		if (x1 < x2)
		{
			x1 = iBarShift(symbol, timeframe, (time1 - 86400), false);
		}

		if (x1 < 0 || x2 < 0)
		{
			return -1;
		}

		for (int i = x2; i <= x1; i++)
		{
			CandleLow = iLow(symbol, timeframe, i);

			if (CandleLow < LowestVal || LowestVal == 0)
			{
				LowestVal  = CandleLow;
				LowestTime = iTime(symbol, timeframe, i);
				LowestID   = i;
			}
		}
	}
	//-- Bars mode ---------------------------------------------------------------------
	else
	{
		int shift = 0;

		if (time1 == time2)
		{
			shift = (int)time1;
		}
		else
		{
			int totalbars = iBars(symbol, timeframe) - 1;

			if (time2 > totalbars || time2 == 0)
			{
				time2 = totalbars;
			}

			shift = iLowest(symbol, timeframe, MODE_LOW, (int)((time2-time1)+1), (int)time1);
		}

		LowestVal  = iLow(symbol, timeframe, shift);
		LowestTime = iTime(symbol, timeframe, shift);
		LowestID   = shift;
	}

	retval = LowestVal;

	if (what_to_get == 2)
	{
		retval = (double)LowestTime;
	}
	else if (what_to_get == 0)
	{
		retval = LowestID;
	}
	
	retval = NormalizeDouble(retval, (int)SymbolInfoInteger(symbol, SYMBOL_DIGITS));

	return retval;
}

bool ModifyOrder(
	long ticket,
	double op,
	double sll = 0,
	double tpl = 0,
	double slp = 0,
	double tpp = 0,
	datetime exp = 0,
	color clr = clrNONE
) {
	int bs = 1;

	if (LoadedType() == 1)
	{
		if (OrderType() == POSITION_TYPE_SELL)
		{bs = -1;} // Positive when Buy, negative when Sell
	}
	else
	{
		if (
				OrderType() == ORDER_TYPE_SELL
			|| OrderType() == ORDER_TYPE_SELL_STOP
			|| OrderType() == ORDER_TYPE_SELL_LIMIT
		)
		{bs = -1;} // Positive when Buy, negative when Sell
	}

	while (true)
	{
		uint time0 = GetTickCount();
		
		if (LoadedType() == 1)
		{
			if (!PositionSelectByTicket(ticket)) {return false;}
		}
		else
		{
			if (!OrderSelect(ticket)) {return false;}
		}

		string symbol      = OrderSymbol();
		int type           = OrderType();
		int digits         = (int)SymbolInfoInteger(symbol,SYMBOL_DIGITS);
		double ask         = SymbolInfoDouble(symbol,SYMBOL_ASK);
		double bid         = SymbolInfoDouble(symbol,SYMBOL_BID);
		double point       = SymbolInfoDouble(symbol,SYMBOL_POINT);
		double stoplevel   = point * SymbolInfoInteger(symbol, SYMBOL_TRADE_STOPS_LEVEL);
		double freezelevel = point * SymbolInfoInteger(symbol, SYMBOL_TRADE_FREEZE_LEVEL);

		if (OrderType() < 2) {op = OrderOpenPrice();} else {op = NormalizeDouble(op,digits);}
		
		sll = NormalizeDouble(sll,digits);
		tpl = NormalizeDouble(tpl,digits);

		if (op < 0 || op >= EMPTY_VALUE || sll < 0 || slp < 0 || tpl < 0 || tpp < 0)
		{
			break;
		}

		//-- OP -----------------------------------------------------------
		// https://book.mql4.com/appendix/limits
		if (type == ORDER_TYPE_BUY_LIMIT)
		{
			if (ask - op < stoplevel) {op = ask - stoplevel;}
			if (ask - op <= freezelevel) {op = ask - freezelevel - point;}
		}
		else if (type == ORDER_TYPE_BUY_STOP)
		{
			if (op - ask < stoplevel) {op = ask + stoplevel;}
			if (op - ask <= freezelevel) {op = ask + freezelevel + point;}
		}
		else if (type == ORDER_TYPE_SELL_LIMIT)
		{
			if (op - bid < stoplevel) {op = bid + stoplevel;}
			if (op - bid <= freezelevel) {op = bid + freezelevel + point;}
		}
		else if (type == ORDER_TYPE_SELL_STOP)
		{
			if (bid - op < stoplevel) {op = bid - stoplevel;}
			if (bid - op < freezelevel) {op = bid - freezelevel - point;}
		}

		op = NormalizeDouble(op, digits);

		//-- SL and TP ----------------------------------------------------
		double sl = 0, tp = 0, vsl = 0, vtp = 0;

		sl = AlignStopLoss(symbol, type, op, attrStopLoss(), sll, slp);

		if (sl < 0) {break;}

		tp = AlignTakeProfit(symbol, type, op, attrTakeProfit(), tpl, tpp);

		if (tp < 0) {break;}

		if (USE_VIRTUAL_STOPS)
		{
			//-- virtual SL and TP --------------------------------------------
			vsl = sl;
			vtp = tp;
			sl  = 0;
			tp  = 0;

			double askbid = ask;

			if (bs < 0) {askbid = bid;}

			if (vsl > 0 || USE_EMERGENCY_STOPS == "always")
			{
				if (EMERGENCY_STOPS_REL > 0 || EMERGENCY_STOPS_ADD > 0)
				{
					sl = vsl - EMERGENCY_STOPS_REL*MathAbs(askbid-vsl)*bs;

					if (sl <= 0) {sl = askbid;}
					sl = sl-toDigits(EMERGENCY_STOPS_ADD,symbol)*bs;
				}
			}

			if (vtp > 0 || USE_EMERGENCY_STOPS == "always")
			{
				if (EMERGENCY_STOPS_REL>0 || EMERGENCY_STOPS_ADD>0)
				{
					tp=vtp+EMERGENCY_STOPS_REL*MathAbs(vtp-askbid)*bs;

					if (tp <= 0) {tp = askbid;}

					tp = tp + toDigits(EMERGENCY_STOPS_ADD,symbol)*bs;
				}
			}

			vsl = NormalizeDouble(vsl,digits);
			vtp = NormalizeDouble(vtp,digits);
		}

		sl = NormalizeDouble(sl,digits);
		tp = NormalizeDouble(tp,digits);

		//-- modify -------------------------------------------------------
		ResetLastError();
		
		if (USE_VIRTUAL_STOPS)
		{
			if (vsl != attrStopLoss() || vtp != attrTakeProfit())
			{
				VirtualStopsDriver("set", ticket, vsl, vtp, toPips(MathAbs(op-vsl), symbol), toPips(MathAbs(vtp-op), symbol));
			}
		}
		
		bool success = false;
		
		// check if needed to modify
		if (LoadedType() == 1)
		{
			if (
				   sl == NormalizeDouble(PositionGetDouble(POSITION_SL),digits)
				&& tp == NormalizeDouble(PositionGetDouble(POSITION_TP),digits)
				&& exp == OrderExpirationTime()
			) {
				return true;
			}
		}
		else
		{
			if (
				   op == NormalizeDouble(OrderGetDouble(ORDER_PRICE_OPEN),digits)
				&& sl == NormalizeDouble(OrderGetDouble(ORDER_SL),digits)
				&& tp == NormalizeDouble(OrderGetDouble(ORDER_TP),digits)
			) {
				return true;
			}
		}

		// prepare to modify
		MqlTradeRequest request;
		MqlTradeResult result;
		MqlTradeCheckResult check_result;
		ZeroMemory(request);
		ZeroMemory(result);
		ZeroMemory(check_result);

		// modify
		if (LoadedType() == 1)
		{
			// in case of position, only sl and tp are going to be modified
			request.action   = TRADE_ACTION_SLTP;
			request.symbol   = symbol;
			request.position = PositionGetInteger(POSITION_TICKET);
			request.magic    = PositionGetInteger(POSITION_MAGIC);
			request.comment  = PositionGetString(POSITION_COMMENT);
		}
		else
		{
			// in case of pending order
			request.action     = TRADE_ACTION_MODIFY;
			request.order      = ticket;
			request.price      = op;
			request.volume     = OrderGetDouble(ORDER_VOLUME_CURRENT);
			request.magic      = OrderGetInteger(ORDER_MAGIC);
			request.type_time  = ExpirationTypeByTime(symbol, exp);
			request.expiration = exp;
			request.comment    = OrderGetString(ORDER_COMMENT);

			//-- filling type
			uint filling = (uint)SymbolInfoInteger(request.symbol,SYMBOL_FILLING_MODE);

			if (filling == SYMBOL_FILLING_FOK)
			{
				request.type_filling = ORDER_FILLING_FOK;
			}
			else if (filling == SYMBOL_FILLING_IOC)
			{
				request.type_filling = ORDER_FILLING_IOC;
			}
		}
		
		request.sl = sl;
		request.tp = tp;

		if (!OrderCheck(request,check_result))
		{
			Print("OrderCheck() failed: " + (string)check_result.comment + " (" + (string)check_result.retcode + ")");

			return false;
		}

		success = OrderSend(request, result);

		//-- error check --------------------------------------------------
		if (result.retcode != TRADE_RETCODE_DONE)
		{
			string errmsgpfx = "Modify error";
			int erraction = CheckForTradingError(result.retcode, errmsgpfx);

			switch(erraction)
			{
				case 0: break;    // no error
				case 1: continue; // overcomable error
				case 2: break;    // fatal error
			}

			return false;
		}

		//-- finish work --------------------------------------------------
		if (result.retcode == TRADE_RETCODE_DONE)
		{
			//== Wait until MT5 updates its cache
			int w;

			for (w = 0; w < 5000; w++)
			{
				if (((LoadedType() == 1 && PositionSelectByTicket(ticket)) || OrderSelect(ticket)) && (sl == NormalizeDouble(OrderStopLoss(), digits) && tp == NormalizeDouble(OrderTakeProfit(), digits)))
				{
					break;
				}

				Sleep(1);
			}

			if (w == 5000)
			{
				Print("Check error: Modify order stops");  
			}

			if (!((LoadedType() == 1 && PositionSelectByTicket(ticket)) || OrderSelect(ticket)) || (sl != NormalizeDouble(OrderStopLoss(), digits) || tp != NormalizeDouble(OrderTakeProfit(), digits)))
			{
				Print("Something went wrong when trying to modify the stops");

				return false;
			}

			if (!((LoadedType() == 1 && PositionSelectByTicket(ticket)) || OrderSelect(ticket)))
			{
				return false;
			}

			OrderModified((int)ticket);
		}

		break;
	}

	OnTrade();

	return true;
}

int OCODriver()
{
	static long last_known_ticket = 0;
	static long orders1[];
	static long orders2[];
	int i, size;

	int total = OrdersTotal();

	for (int pos=total-1; pos>=0; pos--)
	{
		if (LoadPendingOrder(OrderGetTicket(pos)))
		{
			long ticket = OrderTicket();

			//-- end here if we reach the last known ticket
			if (ticket == last_known_ticket) {break;}

			//-- set the last known ticket, only if this is the first iteration
			if (pos == total-1) {
				last_known_ticket = ticket;
			}

			//-- we are searching for pending orders, skip trades
			if (OrderType() <= ORDER_TYPE_SELL) {continue;}

			//--
			if (StringSubstr(OrderComment(), 0, 5) == "[oco:")
			{
				int ticket_oco = StrToInteger(StringSubstr(OrderComment(), 5, StringLen(OrderComment())-1)); 

				bool found = false;
				size = ArraySize(orders2);
				for (i=0; i<size; i++)
				{
					if (orders2[i] == ticket_oco) {
						found = true;
						break;
					}
				}

				if (found == false) {
					ArrayResize(orders1, size+1);
					ArrayResize(orders2, size+1);
					orders1[size] = ticket_oco;
					orders2[size] = ticket;
				}
			}
		}
	}

	size = ArraySize(orders1);
	int dbremove = false;

	for (i = size - 1; i >= 0; i--)
	{
		if (LoadPendingOrder(orders1[i]) == false || OrderType() <= ORDER_TYPE_SELL)
		{
			if (LoadPendingOrder(orders2[i])) {
				if (DeleteOrder(orders2[i]))
				{
					dbremove = true;
				}
			}
			else {
				dbremove = true;
			}
			
			if (dbremove == true)
			{
				ArrayStripKey(orders1, i);
				ArrayStripKey(orders2, i);
			}
		}
	}

	size = ArraySize(orders2);
	dbremove = false;
	for (i=size-1; i>=0; i--)
	{
		if (LoadPendingOrder(orders2[i]) == false || OrderType() <= ORDER_TYPE_SELL)
		{
			if (LoadPendingOrder(orders1[i])) {
				if (DeleteOrder(orders1[i]))
				{
					dbremove = true;
				}
			}
			else {
				dbremove = true;
			}
			
			if (dbremove == true)
			{
				ArrayStripKey(orders1, i);
				ArrayStripKey(orders2, i);
			}
		}
	}

	return true;
}

int ObjectGetShiftByValue(string name, double value) {
   ENUM_TIMEFRAMES timeframe=TFMigrate(PERIOD_CURRENT);
   datetime Arr[];
   MqlRates mql4[];
   if(ObjectGetTimeByValue(0,name,value)<0) {return(-1);}
   CopyRates(NULL,timeframe,0,1,mql4);
      if(CopyTime(NULL, timeframe, mql4[0].time, ObjectGetTimeByValue(0,name,value), Arr)>0) {return(ArraySize(Arr)-1);}
      else {return(-1);}
}

int ObjectGetShiftByValue(long chart_id, string name, double value) {
   ENUM_TIMEFRAMES timeframe=TFMigrate(PERIOD_CURRENT);
   datetime Arr[];
   MqlRates mql4[];
   if(ObjectGetTimeByValue(chart_id,name,value)<0) {return(-1);}
   CopyRates(NULL, timeframe, 0, 1, mql4);
   if(CopyTime(NULL, timeframe, mql4[0].time, ObjectGetTimeByValue(chart_id,name,value),Arr)>0) {return(ArraySize(Arr)-1);}
   else {return(-1);}
}

double ObjectGetValueByShift(string name, int shift)
{
	MqlRates rates[];
	CopyRates(NULL, PERIOD_CURRENT, shift, 1, rates);

	return ObjectGetValueByTime(0, name, rates[0].time, 0);
}

double ObjectGetValueByShift(long ctart_id, string name, int shift)
{
	MqlRates rates[];
	CopyRates(NULL, PERIOD_CURRENT, shift, 1, rates);

	return ObjectGetValueByTime(ctart_id, name, rates[0].time, 0);
}

bool OnTimerSet(double seconds)
{
   if (seconds<=0) {
      EventKillTimer();
   }
   else if (seconds < 1) {
      return (EventSetMillisecondTimer((int)(seconds*1000)));  
   }
   else {
      return (EventSetTimer((int)seconds));
   }
   
   return true;
}

class OnTradeEventDetector
{
private:
	//--- structures
	struct EventValues
	{
		// special fields
		string   reason,
		         detail;

		// order related fields
		long     magic,
		         ticket;
		int      type;
		datetime timeClose,
		         timeOpen,
		         timeExpiration;
		double   commission,
		         priceOpen,
		         priceClose,
		         profit,
		         stopLoss,
		         swap,
		         takeProfit,
		         volume;
		string   comment,
		         symbol;
	};

	struct Position
	{
		ENUM_POSITION_TYPE type;
		ENUM_POSITION_REASON reason;
		long     positionId,
		         magic,
		         ticket,
		         timeMs,
		         timeUpdateMs;
		datetime time,
					timeExpiration,
		         timeUpdate;
		double   priceCurrent,
		         priceOpen,
		         profit,
		         stopLoss,
		         swap,
		         takeProfit,
		         volume;
		string   externalId,
		         comment,
		         symbol;
	};

	struct PendingOrder
	{
		ENUM_ORDER_TYPE type;
		ENUM_ORDER_STATE state;
		ENUM_ORDER_TYPE_FILLING typeFilling;
		ENUM_ORDER_TYPE_TIME typeTime;
		ENUM_ORDER_REASON reason;
		long     magic,
		         positionId,
		         positionById,
		         ticket,
		         timeSetupMs,
		         timeDoneMs;
		datetime timeDone,
		         timeExpiration,
		         timeSetup;
		double   priceCurrent,
		         priceOpen,
		         priceStopLimit,
		         stopLoss,
		         takeProfit,
		         volume,
		         volumeInitial;
		string   externalId,
		         comment,
		         symbol;
	};
	
	struct PositionExpirationTimes
	{
		long ticket;
		datetime timeExpiration;
	};

	//--- variables and arrays
	bool debug;
	
	// Because we can have multiple new events at once, the idea is
	// to run the detector repeatedly until no new event is detected.
	// When this variable is true, it means that the event detection
	// is repeated. It should stop repeating when no new event is detected.
	bool isRepeat;

	int eventValuesQueueIndex;
	EventValues eventValues[];

	PendingOrder previousPendingOrders[];
	PendingOrder pendingOrders[];

	Position previousPositions[];
	Position positions[];

	PositionExpirationTimes positionExpirationTimes[];

	//--- methods

	/**
	* Like ArrayCopy(), but for any type.
	*/
	template<typename T>
	void CopyList(T &dest[], T &src[])
	{
		int size = ArraySize(src);
		ArrayResize(dest, size);

		for (int i = 0; i < size; i++)
		{
			dest[i] = src[i];
		}
	}

	/**
	* Overloaded method 1 of 2
	*/
	int MakeListOf(PendingOrder &list[])
	{
		ArrayResize(list, 0);

		int count        = OrdersTotal();
		int howManyAdded = 0;

		for (int index = 0; index < count; index++)
		{
			if (OrderGetTicket(index) <= 0) continue;

			ENUM_ORDER_TYPE orderType = (ENUM_ORDER_TYPE)OrderGetInteger(ORDER_TYPE);

			if (
				orderType != ORDER_TYPE_BUY_LIMIT
				&& orderType != ORDER_TYPE_SELL_LIMIT
				&& orderType != ORDER_TYPE_BUY_STOP
				&& orderType != ORDER_TYPE_SELL_STOP
				&& orderType != ORDER_TYPE_BUY_STOP_LIMIT
				&& orderType != ORDER_TYPE_SELL_STOP_LIMIT
			) {
				continue;
			}

			howManyAdded++;
			ArrayResize(list, howManyAdded);
			int i = howManyAdded - 1;

			// enum types
			list[i].type        = (ENUM_ORDER_TYPE)OrderGetInteger(ORDER_TYPE);
			list[i].state       = (ENUM_ORDER_STATE)OrderGetInteger(ORDER_STATE);
			list[i].typeFilling = (ENUM_ORDER_TYPE_FILLING)OrderGetInteger(ORDER_TYPE_FILLING);
			list[i].typeTime    = (ENUM_ORDER_TYPE_TIME)OrderGetInteger(ORDER_TYPE_TIME);
			list[i].reason      = (ENUM_ORDER_REASON)OrderGetInteger(ORDER_REASON);

			// long
			list[i].magic        = (long)OrderGetInteger(ORDER_MAGIC);
			list[i].positionId   = (long)OrderGetInteger(ORDER_POSITION_ID);
			list[i].positionById = (long)OrderGetInteger(ORDER_POSITION_BY_ID);
			list[i].ticket       = (long)OrderGetInteger(ORDER_TICKET);
			list[i].timeSetupMs  = (long)OrderGetInteger(ORDER_TIME_SETUP_MSC);
			list[i].timeDoneMs   = (long)OrderGetInteger(ORDER_TIME_DONE_MSC);

			// datetime
			list[i].timeDone       = (datetime)OrderGetInteger(ORDER_TIME_DONE);
			list[i].timeExpiration = (datetime)OrderGetInteger(ORDER_TIME_EXPIRATION);
			list[i].timeSetup      = (datetime)OrderGetInteger(ORDER_TIME_SETUP);

			// double
			list[i].priceCurrent   = OrderGetDouble(ORDER_PRICE_CURRENT);
			list[i].priceOpen      = OrderGetDouble(ORDER_PRICE_OPEN);
			list[i].priceStopLimit = OrderGetDouble(ORDER_PRICE_STOPLIMIT);
			list[i].stopLoss       = OrderGetDouble(ORDER_SL);
			list[i].takeProfit     = OrderGetDouble(ORDER_TP);
			list[i].volume         = OrderGetDouble(ORDER_VOLUME_CURRENT);
			list[i].volumeInitial  = OrderGetDouble(ORDER_VOLUME_INITIAL);

			// string
			list[i].externalId = OrderGetString(ORDER_EXTERNAL_ID);
			list[i].comment    = OrderGetString(ORDER_COMMENT);
			list[i].symbol     = OrderGetString(ORDER_SYMBOL);
		}

		return howManyAdded;
	}

	/**
	* Overloaded method 2 of 2
	*/
	int MakeListOf(Position &list[])
	{
		ArrayResize(list, 0);

		int count        = PositionsTotal();
		int howManyAdded = 0;

		for (int index = 0; index < count; index++)
		{
			if (PositionGetTicket(index) <= 0) continue;

			howManyAdded++;
			ArrayResize(list, howManyAdded);
			int i = howManyAdded - 1;

			// enum types
			list[i].type   = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
			list[i].reason = (ENUM_POSITION_REASON)PositionGetInteger(POSITION_REASON);

			// long
			list[i].positionId   = (long)PositionGetInteger(POSITION_IDENTIFIER);
			list[i].magic        = (long)PositionGetInteger(POSITION_MAGIC);
			list[i].ticket       = (long)PositionGetInteger(POSITION_TICKET);
			list[i].timeMs       = (long)PositionGetInteger(POSITION_TIME_MSC);
			list[i].timeUpdateMs = (long)PositionGetInteger(POSITION_TIME_UPDATE_MSC);

			// datetime
			list[i].time           = (datetime)PositionGetInteger(POSITION_TIME);
			list[i].timeExpiration = (datetime)0;
			list[i].timeUpdate     = (datetime)PositionGetInteger(POSITION_TIME_UPDATE);

			// double
			list[i].priceCurrent = PositionGetDouble(POSITION_PRICE_CURRENT);
			list[i].priceOpen    = PositionGetDouble(POSITION_PRICE_OPEN);
			list[i].profit       = PositionGetDouble(POSITION_PROFIT);
			list[i].stopLoss     = PositionGetDouble(POSITION_SL);
			list[i].swap         = PositionGetDouble(POSITION_SWAP);
			list[i].takeProfit   = PositionGetDouble(POSITION_TP);
			list[i].volume       = PositionGetDouble(POSITION_VOLUME);

			// string
			list[i].externalId = PositionGetString(POSITION_EXTERNAL_ID);
			list[i].comment    = PositionGetString(POSITION_COMMENT);
			list[i].symbol     = PositionGetString(POSITION_SYMBOL);

			// extract expiration
			list[i].timeExpiration = expirationWorker.GetExpiration(list[i].ticket);

			if (USE_VIRTUAL_STOPS)
			{
				list[i].stopLoss   = VirtualStopsDriver("get sl", list[i].ticket);
				list[i].takeProfit = VirtualStopsDriver("get tp", list[i].ticket);
			}
		}

		return howManyAdded;
	}

	/**
	* This method loops through 2 lists of items and finds a difference. This difference is the event.
	* "Items" are either pending orders or positions.
	*
	* Returns true if an event is detected or false if not.
	*/
	template<typename ITEMS_TYPE> 
	bool DetectEvent(ITEMS_TYPE &previousItems[], ITEMS_TYPE &currentItems[])
	{
		ITEMS_TYPE item;
		string reason   = "";
		string detail   = "";
		int countBefore = ArraySize(previousItems);
		int countNow    = ArraySize(currentItems);

		// closed
		if (reason == "") {
			for (int index = 0; index < countBefore; index++) {
				item = FindMissingItem(previousItems, currentItems);

				if (item.ticket > 0) {
					DeleteItem(previousItems, item);
					reason = "close";

					break;
				}
			}
		}

		// new
		if (reason == "") {
			for (int index = 0; index < countNow; index++) {
				item = FindMissingItem(currentItems, previousItems);

				if (item.ticket > 0) {
					if (
						item.type < 2 // it's a running trade
						&& item.ticket != attrTicketParent(item.ticket)
					) {
						// In MQL4: When a trade is closed partially, the ticket changes.
						// The original (parent) trade is closed and a new one is created,
						// with a different ticket.
						reason = "decrement";
					}
					else {
						reason = "new";
					}

					PushItem(previousItems, item);

					break;
				}
			}
		}

		// modified
		if (reason == "") {
			if (countBefore != countNow) {
				Print("OnTrade event detector: Uncovered situation reached");
			}

			for (int index = 0; index < countNow; index++) {
				int previousIndex = -1;

				ITEMS_TYPE current = currentItems[index];
				ITEMS_TYPE previous;
				previous.ticket = 0;

				for (int j = 0; j < countBefore; j++) {
					if (current.ticket == previousItems[j].ticket) {
						previousIndex = j;
						previous = previousItems[j];

						break;
					}
				}

				if (current.ticket != previous.ticket) {
					Print("OnTrade event detector: Uncovered situation reached (2)");
				}

				if (previous.volume < current.volume) {
					previousItems[previousIndex].volume = current.volume;
					item = previousItems[previousIndex];

					reason = "increment";

					break;
				}

				if (previous.volume > current.volume) {
					previousItems[previousIndex].volume = current.volume;
					item = previousItems[previousIndex];

					reason = "decrement";

					break;
				}

				if (
					previous.stopLoss != current.stopLoss
					&& previous.takeProfit != current.takeProfit
				) {
					previousItems[previousIndex].stopLoss = current.stopLoss;
					previousItems[previousIndex].takeProfit = current.takeProfit;
					item = previousItems[previousIndex];

					reason = "modify";
					detail = "sltp";

					break;
				}
				// SL modified
				else if (previous.stopLoss != current.stopLoss) {
					previousItems[previousIndex].stopLoss = current.stopLoss;
					item = previousItems[previousIndex];

					reason = "modify";
					detail = "sl";

					break;
				}
				// TP modified
				else if (previous.takeProfit != current.takeProfit) {
					previousItems[previousIndex].takeProfit = current.takeProfit;
					item = previousItems[previousIndex];

					reason = "modify";
					detail = "tp";

					break;
				}

				if (previous.timeExpiration != current.timeExpiration) {
					previousItems[previousIndex].timeExpiration = current.timeExpiration;
					item = previousItems[previousIndex];

					reason = "modify";
					detail = "expiration";

					break;
				}
			}
		}

		if (reason == "")
		{
			return false;
		}

		UpdateValues(item, reason, detail);

		return true;
	}

	/**
	* From the source list of orders or positions, find the item that is missing
	* in the target list of orders or positions. The searching is by the item's ticket.
	*
	* If all items from the source list exist in the target list, return an empty item with ticket 0.
	* If for some item in source list there is no item in the target list, return that source item.
	*/
	template<typename T> 
	T FindMissingItem(T &source[], T &target[])
	{
		int sourceCount = ArraySize(source);
		int targetCount  = ArraySize(target);
		T item;
		item.ticket = 0;

		long ticket = 0;

		for (int i = 0; i < sourceCount; i++)
		{
			bool found = false;

			for (int j = 0; j < targetCount; j++)
			{
				if (source[i].ticket == target[j].ticket)
				{
					found = true;
					break;
				}
			}

			if (found == false)
			{
				item = source[i];
				break;
			}
		}

		return item;
	}

	/**
	* From the list of previous orders or positions, find and remove the
	* provided item.
	*/
	template<typename T> 
	bool DeleteItem(T &list[], T &item)
	{
		int listCount = ArraySize(list);
		bool removed = false;

		for (int i = 0; i < listCount; i++)
		{
			if (list[i].ticket == item.ticket) {
				ArrayStripKey(list, i);
				removed = true;

				break;
			}
		}

		return removed;
	}

	/**
	* Push a new item in the list
	*/
	template<typename T> 
	void PushItem(T &list[], T &item)
	{
		int listCount = ArraySize(list);

		ArrayResize(list, listCount + 1);

		list[listCount] = item;
	}

	/**
	* Overloaded method 1 of 2
	*/
	void UpdateValues(Position &item, string reason, string detail)
	{
		long ticket        = item.ticket;
		datetime timeOpen  = item.time;
		datetime timeClose = (datetime)0;
		double priceOpen   = item.priceOpen;
		double priceClose  = item.priceCurrent;
		double profit      = item.profit;
		double swap        = item.swap;
		double commission  = 0.0;
		double volume      = item.volume;

		if (reason == "close" || reason == "decrement")
		{
			if (HistorySelectByPosition(item.positionId))
			{
				int total = HistoryDealsTotal();

				// Fallback:
				// After reports and tests, one year after I re-wrote this class with
				// great care and tests, I noted that the last deal doesn't give us
				// proper data. It doesn't even apear as a close deal. For that
				// reason, as a second variant I'm getting data from orders
				// and the position itself.
				//
				// In the future, check if things are working normally again and remove
				// the fallback code.
				int totalOrders = HistoryOrdersTotal();

				if (total > 0)
				{
					long firstTicket = (long)HistoryDealGetTicket(0);
					long lastTicket  = (long)HistoryDealGetTicket(total - 1);
					long lastOrderTicket = (long)HistoryOrderGetTicket(totalOrders - 1);

					// Ticket is the ticket of the previous deal, the one before the last one
					ticket = (long)HistoryDealGetTicket(total - 2);

					if (HistoryDealSelect(firstTicket)) {
						priceOpen = HistoryDealGetDouble(firstTicket, DEAL_PRICE);
						timeOpen  = (datetime)HistoryDealGetInteger(firstTicket, DEAL_TIME);
					}

					if (HistoryDealSelect(lastTicket)) {
						timeClose  = (datetime)HistoryDealGetInteger(lastTicket, DEAL_TIME);
						priceClose = HistoryDealGetDouble(lastTicket, DEAL_PRICE);

						profit     = HistoryDealGetDouble(lastTicket, DEAL_PROFIT);
						swap       = HistoryDealGetDouble(lastTicket, DEAL_SWAP);
						commission = HistoryDealGetDouble(lastTicket, DEAL_COMMISSION);
						
						volume = HistoryDealGetDouble(lastTicket, DEAL_VOLUME);
					}

					// Find why the position has been closed
					if (detail == "")
					{
						if (
							item.timeExpiration > 0
							&& item.timeExpiration <= timeClose
						) {
							detail = "expiration";
						}
					}

					if (detail == "")
					{
						if (HistoryDealSelect(lastTicket)) {
							ENUM_DEAL_REASON dealReason = (ENUM_DEAL_REASON)HistoryDealGetInteger(lastTicket, DEAL_REASON);

							switch (dealReason)
							{
								case DEAL_REASON_SL: detail = "sl"; break;
								case DEAL_REASON_TP: detail = "tp"; break;
								case DEAL_REASON_SO: detail = "so"; break;
							}
						}
					}
				}
			}
		}

		int i = eventValuesQueueIndex;

		eventValues[i].reason = reason;
		eventValues[i].detail = detail;

		eventValues[i].priceClose     = priceClose;
		eventValues[i].timeClose      = timeClose;
		eventValues[i].comment        = item.comment;
		eventValues[i].commission     = commission;
		eventValues[i].timeExpiration = item.timeExpiration;
		eventValues[i].volume         = volume;
		eventValues[i].magic          = item.magic;
		eventValues[i].priceOpen      = priceOpen;
		eventValues[i].timeOpen       = timeOpen;
		eventValues[i].profit         = profit;
		eventValues[i].stopLoss       = item.stopLoss;
		eventValues[i].swap           = swap;
		eventValues[i].symbol         = item.symbol;
		eventValues[i].takeProfit     = item.takeProfit;
		eventValues[i].ticket         = ticket;
		eventValues[i].type           = item.type;

		if (debug)
		{
			PrintUpdatedValues();
		}
	}

	/**
	* Overloaded method 2 of 2
	*/
	void UpdateValues(PendingOrder &item, string reason, string detail)
	{
		datetime timeExpiration = item.timeExpiration;

		// When the lifetime of the order is ORDER_TIME_DAY,
		// the expiration (ORDER_TIME_EXPIRATION) equals to the time of opening.
		// Here we fix this.
		if (item.typeTime == ORDER_TIME_DAY)
		{
			timeExpiration = (datetime)(MathFloor(((double)item.timeSetup + 86400.0) / 86400.0) * 86400.0);
		}

		int i = eventValuesQueueIndex;

		eventValues[i].reason = reason;
		eventValues[i].detail = detail;

		eventValues[i].priceClose     = item.priceCurrent;
		eventValues[i].timeClose      = item.timeDone;
		eventValues[i].comment        = item.comment;
		eventValues[i].commission     = 0.0;
		eventValues[i].timeExpiration = timeExpiration;
		eventValues[i].volume         = item.volume;
		eventValues[i].magic          = item.magic;
		eventValues[i].priceOpen      = item.priceOpen;
		eventValues[i].timeOpen       = item.timeSetup;
		eventValues[i].profit         = 0.0;
		eventValues[i].stopLoss       = item.stopLoss;
		eventValues[i].swap           = 0.0;
		eventValues[i].symbol         = item.symbol;
		eventValues[i].takeProfit     = item.takeProfit;
		eventValues[i].ticket         = item.ticket;
		eventValues[i].type           = item.type;

		if (debug)
		{
			PrintUpdatedValues();
		}
	}

	void PrintUpdatedValues()
	{
		Print(
			" <<<\n",
			" | reason: ", e_Reason(),
			" | detail: ", e_ReasonDetail(),
			" | ticket: ", e_attrTicket(),
			" | type: ", EnumToString((ENUM_ORDER_TYPE)e_attrType()),
			"\n",
			" | openTime : ", e_attrOpenTime(),
			" | openPrice : ", e_attrOpenPrice(),
			"\n",
			" | closeTime: ", e_attrCloseTime(),
			" | closePrice: ", e_attrClosePrice(),
			"\n",
			" | volume: ", e_attrLots(),
			" | sl: ", e_attrStopLoss(),
			" | tp: ", e_attrTakeProfit(),
			" | profit: ", e_attrProfit(),
			" | swap: ", e_attrSwap(),
			" | exp: ", e_attrExpiration(),
			" | comment: ", e_attrComment(),
			"\n >>>"
		);
	}

	int AddEventValues()
	{
		eventValuesQueueIndex++;
		ArrayResize(eventValues, eventValuesQueueIndex + 1);

		return eventValuesQueueIndex;
	}

	int RemoveEventValues()
	{
		if (eventValuesQueueIndex == -1)
		{
			Print("Cannot remove event values, add them first. (in function ", __FUNCTION__, ")");
		}
		else
		{
			eventValuesQueueIndex--;
			ArrayResize(eventValues, eventValuesQueueIndex + 1);
		}

		return eventValuesQueueIndex;
	}

public:
	/**
	* Default constructor
	*/
	OnTradeEventDetector(void)
	{
		debug = false;
		isRepeat = false;
		eventValuesQueueIndex = -1;
	};

	bool Start()
	{
		AddEventValues();

		if (isRepeat == false) {
			MakeListOf(pendingOrders);
			MakeListOf(positions);
		}

		bool success = false;

		if (!success) success = DetectEvent(previousPendingOrders, pendingOrders);

		if (!success) success = DetectEvent(previousPositions, positions);

		//CopyList(previousPendingOrders, pendingOrders);
		//CopyList(previousPositions, positions);

		isRepeat = success; // Repeat until no success

		return success;
	}

	void End()
	{
		RemoveEventValues();
	}

	string EventValueReason() {return eventValues[eventValuesQueueIndex].reason;}
	string EventValueDetail() {return eventValues[eventValuesQueueIndex].detail;}

	int EventValueType() {return eventValues[eventValuesQueueIndex].type;}

	datetime EventValueTimeClose()      {return eventValues[eventValuesQueueIndex].timeClose;}
	datetime EventValueTimeOpen()       {return eventValues[eventValuesQueueIndex].timeOpen;}
	datetime EventValueTimeExpiration() {return eventValues[eventValuesQueueIndex].timeExpiration;}

	long EventValueMagic()  {return eventValues[eventValuesQueueIndex].magic;}
	long EventValueTicket() {return eventValues[eventValuesQueueIndex].ticket;}

	double EventValueCommission() {return eventValues[eventValuesQueueIndex].commission;}
	double EventValuePriceOpen()  {return eventValues[eventValuesQueueIndex].priceOpen;}
	double EventValuePriceClose() {return eventValues[eventValuesQueueIndex].priceClose;}
	double EventValueProfit()     {return eventValues[eventValuesQueueIndex].profit;}
	double EventValueStopLoss()   {return eventValues[eventValuesQueueIndex].stopLoss;}
	double EventValueSwap()       {return eventValues[eventValuesQueueIndex].swap;}
	double EventValueTakeProfit() {return eventValues[eventValuesQueueIndex].takeProfit;}
	double EventValueVolume()     {return eventValues[eventValuesQueueIndex].volume;}

	string EventValueComment() {return eventValues[eventValuesQueueIndex].comment;}
	string EventValueSymbol()  {return eventValues[eventValuesQueueIndex].symbol;}
};

OnTradeEventDetector onTradeEventDetector;

double OrderClosePrice()
{
	int type = LoadedType();

	if (type == 1)
	{
		if (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
		{
			return SymbolInfoDouble(PositionGetString(POSITION_SYMBOL), SYMBOL_BID);
		}
		else if (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL)
		{
			return SymbolInfoDouble(PositionGetString(POSITION_SYMBOL), SYMBOL_ASK);
		}
	}
	if (type == 3) {
		ulong dealTicket = OrderTicket();
		HistoryDealSelect(dealTicket);
		ENUM_DEAL_ENTRY dealEntry = (ENUM_DEAL_ENTRY)HistoryDealGetInteger(dealTicket, DEAL_ENTRY);
		long positionId = HistoryDealGetInteger(dealTicket, DEAL_POSITION_ID);
		double price = HistoryDealGetDouble(dealTicket, DEAL_PRICE);

		HistorySelectByPosition(positionId);
		
		// Search for the first OUT deal after this one and get the price from it

		int total = HistoryDealsTotal();
	
		for (int i = total - 1; i >= 0; i--) {
			ulong ticket = HistoryDealGetTicket(i);
	
			if (ticket == dealTicket) {
				// Get the current value if the deal is the the last one
				if (i == total - 1 && PositionSelectByDeal(ticket))
				{
					if (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
					{
						price = SymbolInfoDouble(PositionGetString(POSITION_SYMBOL), SYMBOL_BID);
					}
					else if (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL)
					{
						price = SymbolInfoDouble(PositionGetString(POSITION_SYMBOL), SYMBOL_ASK);
					}
				}
		
				break;
			}
	
			if (HistoryDealGetInteger(ticket, DEAL_ENTRY) == DEAL_ENTRY_OUT) {
				price = HistoryDealGetDouble(ticket, DEAL_PRICE);
			}
		}
		
		HistoryTradesTotalReset();
		
		return price;
	}
	if (type == 4) {
		// TODO: Why I used deals here?
		ulong dealTicket = OrderTicket();

		if (HistoryDealSelect(dealTicket)) {
			return HistoryDealGetDouble(dealTicket, DEAL_PRICE);
		}
	}

	return(OrderGetDouble(ORDER_PRICE_CURRENT));
}

datetime OrderCloseTime()
{
	int type = LoadedType();

	if (type == 1)
	{
		return 0;
	}

	if (type == 3)
	{
		ulong dealTicket = OrderTicket();
		HistoryDealSelect(dealTicket);
		ENUM_DEAL_ENTRY dealEntry = (ENUM_DEAL_ENTRY)HistoryDealGetInteger(dealTicket, DEAL_ENTRY);
		long positionId = HistoryDealGetInteger(dealTicket, DEAL_POSITION_ID);
		datetime time = (datetime)HistoryDealGetInteger(dealTicket, DEAL_TIME);

		HistorySelectByPosition(positionId);

		// Search for the first OUT deal after this one and get the time from it

		int total = HistoryDealsTotal();

		for (int i = total - 1; i >= 0; i--) {
			ulong ticket = HistoryDealGetTicket(i);

			if (ticket == dealTicket) {
				if (i == total - 1 && PositionSelectByDeal(ticket))
				{
					time = (datetime)0;
				}

				break;
			}

			if (HistoryDealGetInteger(ticket, DEAL_ENTRY) == DEAL_ENTRY_OUT) {
				time = (datetime)HistoryDealGetInteger(ticket, DEAL_TIME);
			}
		}

		HistoryTradesTotalReset();

		return time;
	}

	if (type == 4)
	{
		ulong orderTicket = OrderTicket();
		
		if (HistoryOrderSelect(orderTicket)) {
			return (datetime)HistoryOrderGetInteger(orderTicket, ORDER_TIME_DONE);
		}
	}
	
	return (datetime)OrderGetInteger(ORDER_TIME_DONE);
}

string OrderComment()
{
	int type = LoadedType();

	if (type == 1) {return PositionGetString(POSITION_COMMENT);}
	if (type == 3) {
		ulong ticket = OrderTicket();
		
		if (HistoryDealSelect(ticket)) {
			return HistoryOrderGetString(HistoryDealGetInteger(ticket, DEAL_POSITION_ID), ORDER_COMMENT);
		}
	}
	if (type == 4) {
		ulong ticket = OrderTicket();
		
		if (HistoryOrderSelect(ticket)) {
			return HistoryOrderGetString(ticket, ORDER_COMMENT);
		}
	}

	return OrderGetString(ORDER_COMMENT);
}

double OrderCommission()
{
	int type = LoadedType();

	if (type == 1) {return PositionGetDouble(POSITION_COMMISSION);}
	if (type == 3) {
		ulong ticket = OrderTicket();

		if (HistoryDealSelect(ticket)) {
			return HistoryDealGetDouble(ticket, DEAL_COMMISSION);
		}
	}
	if (type == 4) {return 0;}

	return 0;
}

long OrderCreate(
	string   symbol     = "",
	int      type       = ORDER_TYPE_BUY,
	double   lots       = 0,
	double   op         = 0,
	double   sll        = 0,
	double   tpl        = 0,
	double   slp        = 0,
	double   tpp        = 0,
	double   slippage   = 0,
	ulong    magic      = 0,
	string   comment    = NULL,
	color    arrowcolor = clrNONE,
	datetime expiration = 0,
	bool     oco        = false
	)
{
	OnTrade(); // When position is closed by sl or tp, this event is not fired (by MetaTrader) until the end of the tick, and if a new position is opened, it will be missed. 

	uint time0 = GetTickCount(); // used to measure speed of execution of the order
	
	bool placeExpirationObject = false; // whether or not to create an object for expiration for trades

	bool closing = false;
	double lots0 = 0;
	long type0   = type;

	if (
		   (AccountInfoInteger(ACCOUNT_MARGIN_MODE) == ACCOUNT_MARGIN_MODE_RETAIL_NETTING)
		&& (type == POSITION_TYPE_BUY || type == POSITION_TYPE_SELL)
		)
	{
		if (PositionSelect(symbol))
		{
			if ((int)PositionGetInteger(POSITION_TYPE) != type)
			{
				closing = true;
			}

			lots0 = NormalizeDouble(PositionGetDouble(POSITION_VOLUME), 5);
			type0 = PositionGetInteger(POSITION_TYPE);
		}
	}

	ulong ticket = -1;

	// calculate buy/sell flag (1 when Buy or -1 when Sell)
	int bs = 1;

	if (
		   type == ORDER_TYPE_SELL
		|| type == ORDER_TYPE_SELL_STOP
		|| type == ORDER_TYPE_SELL_LIMIT
	)
	{
		bs = -1;
	}

	if (symbol == "") {symbol = Symbol();}

	lots = AlignLots(symbol, lots);

	int digits = 0;
	double ask = 0, bid = 0, point = 0, ticksize = 0;
	double sl = 0, tp = 0;
	double vsl = 0, vtp = 0;
	bool successed = false;

	//-- attempts to send position/order ---------------------------------
	while (true)
	{
		digits   = (int)SymbolInfoInteger(symbol, SYMBOL_DIGITS);
		ask      = SymbolInfoDouble(symbol, SYMBOL_ASK);
		bid      = SymbolInfoDouble(symbol, SYMBOL_BID);
		point    = SymbolInfoDouble(symbol, SYMBOL_POINT);
		ticksize = SymbolInfoDouble(symbol, SYMBOL_TRADE_TICK_SIZE);

		//- not enough money check: fix maximum possible lot by margin required, or quit
		if ((type == POSITION_TYPE_BUY || type == POSITION_TYPE_SELL) && closing == false)
		{
			double LotStep         = SymbolLotStep(symbol);
			double MinLots         = SymbolMinLot(symbol);
			double margin_required = 0;
			bool ocm               = OrderCalcMargin((ENUM_ORDER_TYPE)type, symbol, 1, SymbolInfoDouble(symbol, SYMBOL_ASK), margin_required);
			static bool not_enough_message = false;

			if (margin_required != 0)
			{
			   double SafeMargin = AccountEquity() * (Maximum_Margin_Percent / 100);
			   double xm = SafeMargin - AccountUsedMargin();
			   double um = AccountFreeMargin();
			   if(xm > AccountFreeMargin() )
			   {
			      um = AccountFreeMargin();
			   }else
			   {
			      um = xm;
			   }		  
				double max_size_by_margin = um  / margin_required;
				
				if (lots > max_size_by_margin)
				{
					double lots_old = lots;
					lots = max_size_by_margin;

					if (lots < MinLots)
					{
						if (not_enough_message == false)
						{
							Print("Not enough money or margin to trade");
						}

						not_enough_message = true;

						return -1;
					}
					else
					{
						lots = MathFloor(lots / LotStep) * LotStep;
						Print("Not enough money to trade " + DoubleToString(lots_old, 2) + ", the volume to trade will be the maximum possible of " + DoubleToString(lots, 2));
					}
				}
			}

			not_enough_message = false;
		}

		// fix the comment, because it seems that the comment is deleted if its lenght is > 31 symbols
		if (StringLen(comment) > 31)
		{
			comment = StringSubstr(comment, 0, 31);
		}

		//- expiration for trades
		if (type == POSITION_TYPE_BUY || type == POSITION_TYPE_SELL)
		{
			if (expiration > 0)
			{
				//- bo broker?
				if (
					   StringLen(symbol) > 6
					&& StringSubstr(symbol, StringLen(symbol) - 2) == "bo"
				) {
					//- convert UNIX to seconds
					if (expiration > TimeCurrent()-100)
					{
						expiration = expiration - TimeCurrent();
					}

					comment = "BO exp:" + (string)expiration;
				}
				else
				{
					// The expiration in this case is a vertical line
					// Comment doesn't always work,
					// because it changes when the trade is partially closed
					placeExpirationObject = true;
				}
			}
		}

		if (type == ORDER_TYPE_BUY || type == ORDER_TYPE_SELL)
		{
			op = (bs > 0) ? ask : bid;
		}

		op  = NormalizeDouble(op, digits);
		sll = NormalizeDouble(sll, digits);
		tpl = NormalizeDouble(tpl, digits);

		if (op < 0 || op >= EMPTY_VALUE || sll < 0 || slp < 0 || tpl < 0 || tpp < 0)
		{
			break;
		}

		//-- SL and TP ----------------------------------------------------
		vsl = 0;
		vtp = 0;

		sl = AlignStopLoss(symbol, type, op, 0, NormalizeDouble(sll,digits), slp);

		if (sl < 0) {break;}

		tp = AlignTakeProfit(symbol, type, op, 0, NormalizeDouble(tpl,digits), tpp);

		if (tp < 0) {break;}

		if (USE_VIRTUAL_STOPS)
		{
			//-- virtual SL and TP --------------------------------------------
			vsl = sl;
			vtp = tp;
			sl = 0;
			tp = 0;
			
			double askbid = (bs > 0) ? ask : bid;
			
			if (vsl > 0 || USE_EMERGENCY_STOPS == "always")
			{
				if (EMERGENCY_STOPS_REL > 0 || EMERGENCY_STOPS_ADD > 0)
				{
					sl = vsl - EMERGENCY_STOPS_REL * MathAbs(askbid - vsl) * bs;

					if (sl <= 0) {sl = askbid;}

					sl = sl - toDigits(EMERGENCY_STOPS_ADD, symbol) * bs;
				}
			}

			if (vtp > 0 || USE_EMERGENCY_STOPS == "always")
			{
				if (EMERGENCY_STOPS_REL > 0 || EMERGENCY_STOPS_ADD > 0)
				{
					tp = vtp + EMERGENCY_STOPS_REL * MathAbs(vtp - askbid) * bs;

					if (tp <= 0) {tp = askbid;}

					tp = tp + toDigits(EMERGENCY_STOPS_ADD, symbol) * bs;
				}
			}

			vsl = NormalizeDouble(vsl, digits);
			vtp = NormalizeDouble(vtp, digits);
		}

		sl = NormalizeDouble(sl, digits);
		tp = NormalizeDouble(tp, digits);

		//-- send ---------------------------------------------------------
		MqlTradeRequest request;
		MqlTradeResult result;
		MqlTradeCheckResult check_result;
		ZeroMemory(request);
		ZeroMemory(result);
		ZeroMemory(check_result);

		ENUM_SYMBOL_TRADE_EXECUTION exec = (ENUM_SYMBOL_TRADE_EXECUTION)SymbolInfoInteger(symbol,SYMBOL_TRADE_EXEMODE);

		//-- fix prices by ticksize
		op = MathRound(op / ticksize) * ticksize;
		sl = MathRound(sl / ticksize) * ticksize;
		tp = MathRound(tp / ticksize) * ticksize;

		request.symbol     = symbol;
		request.type       = (ENUM_ORDER_TYPE)type;
		request.volume     = lots;
		request.price      = op;
		request.deviation  = (ulong)(slippage * PipValue(symbol));
		request.sl         = sl;
		request.tp         = tp;
		request.comment    = comment;
		request.magic      = magic;
		request.type_time  = ExpirationTypeByTime(symbol, expiration);
		request.expiration = expiration;

		//-- request action
		if (type > ORDER_TYPE_SELL)
		{
			request.action = TRADE_ACTION_PENDING;
		}
		else
		{
			request.action = TRADE_ACTION_DEAL;
		}
		//-- filling type
		
		// check ORDER_FILLING_RETURN for pending orders only 
		if (type > ORDER_TYPE_SELL)
		{
			if (IsFillingTypeAllowed(symbol, ORDER_FILLING_RETURN))
				request.type_filling = ORDER_FILLING_RETURN;
			else if (IsFillingTypeAllowed(symbol, ORDER_FILLING_FOK))
				request.type_filling = ORDER_FILLING_FOK;
			else if (IsFillingTypeAllowed(symbol, ORDER_FILLING_IOC))
				request.type_filling = ORDER_FILLING_IOC;
		}
		else
		{
			// in case of positions I would check for SYMBOL_FILLING_ and then set ORDER_FILLING_
			// this is because it appears that IsFillingTypeAllowed() works correct with SYMBOL_FILLING_, but then the position works correctly with ORDER_FILLING_
			// FOK and IOC integer values are not the same for ORDER and SYMBOL

			if (IsFillingTypeAllowed(symbol, SYMBOL_FILLING_FOK))
				request.type_filling = ORDER_FILLING_FOK;
			else if (IsFillingTypeAllowed(symbol, SYMBOL_FILLING_IOC))
				request.type_filling = ORDER_FILLING_IOC;
			else if (IsFillingTypeAllowed(symbol, ORDER_FILLING_RETURN)) // just in case
				request.type_filling = ORDER_FILLING_RETURN;
			else
				request.type_filling = ORDER_FILLING_RETURN;
		}

		if (!OrderCheck(request,check_result))
		{
			Print("OrderCheck() failed: ", (string)check_result.comment, " (", (string)check_result.retcode, ")");

			return -1;
		}

		bool success = OrderSend(request, result);

		//-- check security flag ------------------------------------------
		if (successed == true)
		{
			Print("The program will be removed because of suspicious attempt to create a new position");
			ExpertRemove();
			Sleep(10000);

			break;
		}

		if (success) {successed = true;}

		//-- error check --------------------------------------------------
		if (
			   success == false
			|| (
				   result.retcode != TRADE_RETCODE_DONE
				&& result.retcode != TRADE_RETCODE_PLACED
				&& result.retcode != TRADE_RETCODE_DONE_PARTIAL
			)
		)
		{
			string errmsgpfx = (type > ORDER_TYPE_SELL) ? "New pending order error" : "New position error";

			int erraction = CheckForTradingError(result.retcode, errmsgpfx);

			switch (erraction)
			{
				case 0: break;    // no error
				case 1: continue; // overcomable error
				case 2: break;    // fatal error
			}

			return -1;
		}

		//-- finish work --------------------------------------------------
		if (
			   result.retcode == TRADE_RETCODE_DONE
			|| result.retcode == TRADE_RETCODE_PLACED
			|| result.retcode == TRADE_RETCODE_DONE_PARTIAL
		) {
			ticket = result.order;
			//== Whatever was created, we need to wait until MT5 updates it's cache

			//-- Synchronize: Position
			if (type <= ORDER_TYPE_SELL)
			{
				if (AccountInfoInteger(ACCOUNT_MARGIN_MODE) == ACCOUNT_MARGIN_MODE_RETAIL_NETTING)
				{
					if (closing == false)
					{
						//- new position: 2 situations here - new position or add to position
						//- ... because of that we will check the lot size instead of PositionSelect
						while (true)
						{
							if (PositionSelect(symbol) && (lots0 != NormalizeDouble(PositionGetDouble(POSITION_VOLUME), 5))) {break;}
							Sleep(10);
						}
					}
					else
					{
						//- closing position: full
						if (lots0 == NormalizeDouble(result.volume, 5))
						{
							while (true)
							{
								if (!PositionSelect(symbol)) {break;}
								Sleep(10);
							}
						}
						//- closing position: partial
						else if (lots0 > NormalizeDouble(result.volume, 5))
						{
							while (true)
							{
								if (PositionSelect(symbol) && (lots0 != NormalizeDouble(PositionGetDouble(POSITION_VOLUME), 5))) {break;}
								Sleep(10);
							}
						}
						else if (lots0 < NormalizeDouble(result.volume, 5))
						{
						//-- position reverse
							while (true)
							{
								if (PositionSelect(symbol) && (type0 != PositionGetInteger(POSITION_TYPE))) {break;}
								Sleep(10);
							}
						}
					}
				}
				else if (AccountInfoInteger(ACCOUNT_MARGIN_MODE) == ACCOUNT_MARGIN_MODE_RETAIL_HEDGING)
				{
					if (closing == false)
					{
						while (true)
						{
							if (PositionSelectByTicket(ticket)) {break;}
							Sleep(10);
						}
					}
				}
			}
			//-- Synchronize: Order
			else
			{
				while (true)
				{
					if (LoadPendingOrder(result.order)) {break;}
					Sleep(10);
				}
			}

			//-- fix arrow color (it works only in visual mode)
			// TODO: this piece of code slows down the backtest for some reason
			if (0 && MQLInfoInteger(MQL_VISUAL_MODE) && arrowcolor != CLR_NONE)
			{
				if (type <= ORDER_TYPE_SELL)
				{
					uint t0 = GetTickCount();
					ENUM_OBJECT objType = (type==POSITION_TYPE_BUY) ? OBJ_ARROW_BUY : OBJ_ARROW_SELL;

					// wait for the object to be created (MQL5 is async even here)
					while(true)
					{
						int total        = ObjectsTotal(0,0,objType);
						string name      = ObjectName(0,total-1,0,objType);
						datetime objTime = (datetime)ObjectGetInteger(0,name,OBJPROP_TIME);

						if (objTime > TimeCurrent()-1)
						{
							if (StringFind(name, "#" + IntegerToString(ticket) + " ") == 0)
							{
								ObjectSetInteger(0,name,OBJPROP_COLOR,arrowcolor);
							}

							break;
						}

						if (GetTickCount() - t0 > 1000) break;
					}
				}
				else
				{
					// Pending orders don't have arrows
				}
			}
		}

		if (ticket > 0)
		{
			if (USE_VIRTUAL_STOPS)
			{
				VirtualStopsDriver("set", ticket, vsl, vtp, toPips(MathAbs(op-vsl), symbol), toPips(MathAbs(vtp-op), symbol));
			}

			//-- show some info
			double slip = 0;

			if (LoadPosition(ticket))
			{
				if (placeExpirationObject)
				{
					expirationWorker.SetExpiration(ticket, expiration);
				}

				if (
					   !MQLInfoInteger(MQL_TESTER)
					&& !MQLInfoInteger(MQL_VISUAL_MODE)
					&& !MQLInfoInteger(MQL_OPTIMIZATION)
				) {
					slip = OrderOpenPrice() - op;

					Print(
						"Operation details: Speed ",
						(GetTickCount() - time0),
						" ms | Slippage ",
						DoubleToStr(toPips(slip, symbol), 1),
						" pips"
					);
				}
			}
			
			//-- fix stops in case of slippage
			if (
				   !MQLInfoInteger(MQL_TESTER)
				&& !MQLInfoInteger(MQL_VISUAL_MODE)
				&& !MQLInfoInteger(MQL_OPTIMIZATION)
			) {

				slip = NormalizeDouble(OrderOpenPrice(), digits) - NormalizeDouble(op, digits);

				if (slip != 0 && (OrderStopLoss() != 0 || OrderTakeProfit() != 0))
				{
					Print("Correcting stops because of slippage...");

					sl = OrderStopLoss();
					tp = OrderTakeProfit();

					if (sl != 0 || tp != 0)
					{
						if (sl != 0) {sl = NormalizeDouble(OrderStopLoss() + slip, digits);}
						if (tp != 0) {tp = NormalizeDouble(OrderTakeProfit() + slip, digits);}

						ModifyOrder(ticket, OrderOpenPrice(), sl, tp, 0, 0);
					}
				}
			}

			//RegisterEvent("trade");

			break;
		}

		break;
	}

	if (oco == true && ticket > 0)
	{
		if (USE_VIRTUAL_STOPS)
		{
			sl = vsl;
			tp = vtp;
		}

		sl = (sl > 0) ? NormalizeDouble(MathAbs(op-sl), digits) : 0;
		tp = (tp > 0) ? NormalizeDouble(MathAbs(op-tp), digits) : 0;
		
		int typeoco = type;

		if (typeoco == ORDER_TYPE_BUY_STOP)
		{
			typeoco = ORDER_TYPE_SELL_STOP;
			op = bid - MathAbs(op-ask);
		}
		else if (typeoco == ORDER_TYPE_BUY_LIMIT)
		{
			typeoco = ORDER_TYPE_SELL_LIMIT;
			op = bid + MathAbs(op-ask);
		}
		else if (typeoco == ORDER_TYPE_SELL_STOP)
		{
			typeoco = ORDER_TYPE_BUY_STOP;
			op = ask + MathAbs(op-bid);
		}
		else if (typeoco == ORDER_TYPE_SELL_LIMIT)
		{
			typeoco = ORDER_TYPE_BUY_LIMIT;
			op = ask - MathAbs(op-bid);
		}

		if (typeoco == ORDER_TYPE_BUY_STOP || typeoco == ORDER_TYPE_BUY_LIMIT)
		{
			sl = (sl > 0) ? op - sl : 0;
			tp = (tp > 0) ? op + tp : 0;
		}
		else {
			sl = (sl > 0) ? op + sl : 0;
			tp = (tp > 0) ? op - tp : 0;
		}

		comment = "[oco:" + (string)ticket + "]";

		OrderCreate(
			symbol,
			typeoco,
			lots,
			op,
			sl,
			tp,
			0,
			0,
			slippage,
			magic,
			comment,
			arrowcolor,
			expiration,
			false
		);
	}

	OnTrade();

	return (long)ticket;
}

datetime OrderExpiration()
{
	return OrderExpirationTime();
}

datetime OrderExpirationTime()
{
	int LoadedType = LoadedType();

	if (LoadedType == 1) return expirationWorker.GetExpiration(PositionGetInteger(POSITION_TICKET));
	if (LoadedType == 2) return (datetime)OrderGetInteger(ORDER_TIME_EXPIRATION);

	return 0;
}

double OrderLots()
{
	int type = LoadedType();
	double lots = 0;

	if (type == 1) {
		lots = PositionGetDouble(POSITION_VOLUME);
	}
	else if (type == 3) {
		// Calculate lots as the difference between the intial lots
		// and the lots of all

		if (HistoryDealSelect(OrderTicket())) {
			long positionId = HistoryDealGetInteger(OrderTicket(), DEAL_POSITION_ID);
	
			HistorySelectByPosition(positionId);
	
			int total = HistoryDealsTotal();
	
			lots = 0.0;
	
			for (int i = 0; i < total; i++) {
				ulong ticket = HistoryDealGetTicket(i);
				ENUM_DEAL_ENTRY entry = (ENUM_DEAL_ENTRY)HistoryDealGetInteger(ticket, DEAL_ENTRY);
				double dealVolume = HistoryDealGetDouble(ticket, DEAL_VOLUME);
	
				if (entry == DEAL_ENTRY_IN) {
					lots += dealVolume;
				}
				else {
					// If the last deal is the final close, it's size would be the same as the
					// calculated lots. In this case, skip, otherwise the final lots will be 0.
					if (NormalizeDouble(dealVolume, 4) < NormalizeDouble(lots, 4)) {
						lots -= dealVolume;
					}
				}
			}
		}

		HistoryTradesTotalReset();
	}
	else if (type == 4) {
		ulong ticket = OrderTicket();
		
		if (HistoryOrderSelect(ticket)) {
			lots = HistoryOrderGetDouble(ticket, ORDER_VOLUME_INITIAL);
		}
	}
	else {lots = OrderGetDouble(ORDER_VOLUME_CURRENT);}

	return NormalizeDouble(lots, 2);
}

int OrderMagicNumber()
{
	int type = LoadedType();

	if (type == 1) {return (int)PositionGetInteger(POSITION_MAGIC);}
	if (type == 3) {
		ulong dealTicket = OrderTicket();
		
		if (HistoryDealSelect(dealTicket)) {
			int orderTicket = HistoryDealGetInteger(dealTicket, DEAL_ORDER);
			
			if (HistoryOrderSelect(orderTicket)) {
				return (int)HistoryOrderGetInteger(orderTicket, ORDER_MAGIC);
			}
		}
	}
	if (type == 4) {
		ulong orderTicket = OrderTicket();
		
		if (HistoryOrderSelect(orderTicket)) {
			return (int)HistoryOrderGetInteger(orderTicket, ORDER_MAGIC);
		}
	}

	return (int)OrderGetInteger(ORDER_MAGIC);
}

bool OrderModified(ulong ticket = 0, string action = "set")
{
	static ulong memory[];

	if (ticket == 0)
	{
		ticket = OrderTicket();
		action = "get";
	}
	else if (ticket > 0 && action != "clear")
	{
		action = "set";
	}

	bool modified_status = InArray(memory, ticket);
	
	if (action == "get")
	{
		return modified_status;
	}
	else if (action == "set")
	{
		ArrayEnsureValue(memory, ticket);

		return true;
	}
	else if (action == "clear")
	{
		ArrayStripValue(memory, ticket);

		return true;
	}

	return false;
}

double OrderOpenPrice()
{
	double op  = 0.0;
	int type   = LoadedType();
	int digits = (int)SymbolInfoInteger(OrderSymbol(), SYMBOL_DIGITS);

	if (type == 1)
	{
		op = PositionGetDouble(POSITION_PRICE_OPEN);
	}
	else if (type == 3)
	{
		// Get the value from the very first deal in the position
		
		ulong dealTicket = OrderTicket();

		if (HistoryDealSelect(dealTicket)) {
			ulong positionId = HistoryDealGetInteger(dealTicket, DEAL_POSITION_ID);

			HistorySelectByPosition(positionId);

			ulong ticket = HistoryDealGetTicket(0);

			op = HistoryDealGetDouble(ticket, DEAL_PRICE);
		}

		HistoryTradesTotalReset();
	}
	else if (type == 4)
	{
		ulong orderTicket = OrderTicket();
		
		if (HistoryOrderSelect(orderTicket)) {
			op = HistoryOrderGetDouble(orderTicket, ORDER_PRICE_OPEN);
		}
	}
   else
   {
   	op = OrderGetDouble(ORDER_PRICE_OPEN);
   }

	return NormalizeDouble(op, digits);
}

datetime OrderOpenTime()
{
	datetime time = 0;
	int type      = LoadedType();

	if (type == 1)
	{
		time = (datetime)PositionGetInteger(POSITION_TIME);
	}
	else if (type == 3)
	{
		// Get the value from the very first deal in the position

		ulong dealTicket = OrderTicket();

		if (HistoryDealSelect(dealTicket)) {
			ulong positionId = HistoryDealGetInteger(dealTicket, DEAL_POSITION_ID);
	
			HistorySelectByPosition(positionId);
	
			ulong ticket = HistoryDealGetTicket(0);
			
			time = (datetime)HistoryDealGetInteger(ticket, DEAL_TIME);
		}
		
		HistoryTradesTotalReset();
	}
	else if (type == 4)
	{
		ulong orderTicket = OrderTicket();
		
		if (HistoryOrderSelect(orderTicket)) {
			time = (datetime)HistoryOrderGetInteger(orderTicket, ORDER_TIME_SETUP);
		}
	}
	else
	{
		time = (datetime)OrderGetInteger(ORDER_TIME_SETUP);
	}
	
	return time;
}

double OrderProfit()
{
	int type = LoadedType();

   if (type == 1) {
		return PositionGetDouble(POSITION_PROFIT);
	}
   if (type == 3) {
   	ulong dealTicket = OrderTicket();
   	
   	if (HistoryDealSelect(dealTicket)) {
			return HistoryDealGetDouble(dealTicket, DEAL_PROFIT);
		}
	}
   if (type == 4) {
		return 0;
	}
	
	return 0;
}

double OrderStopLoss()
{
	int type = LoadedType();

	if (type == 1) {return PositionGetDouble(POSITION_SL);}
	if (type == 3) {
		ulong dealTicket = OrderTicket();
		
		if (HistoryDealSelect(dealTicket)) {
			return HistoryDealGetDouble(dealTicket, DEAL_SL);
		}
	}
	if (type == 4) {
		ulong orderTicket = OrderTicket();
		
		if (HistoryOrderSelect(orderTicket)) {
			return HistoryOrderGetDouble(orderTicket, ORDER_SL);
		}
	}

	return OrderGetDouble(ORDER_SL);
}

double OrderSwap()
{
	int type = LoadedType();

	if (type == 1) {return PositionGetDouble(POSITION_SWAP);}
	if (type == 3) {
		ulong dealTicket = OrderTicket();
		
		if (HistoryDealSelect(dealTicket)) {
			return HistoryDealGetDouble(dealTicket, DEAL_SWAP);
		}
	}
	if (type == 4) {return 0;}

	return 0;
}

string OrderSymbol()
{
	int type = LoadedType();

	if (type == 1) {return PositionGetString(POSITION_SYMBOL);}
	if (type == 3) {
		ulong dealTicket = OrderTicket();
		
		if (HistoryDealSelect(dealTicket)) {
			return HistoryDealGetString(dealTicket, DEAL_SYMBOL);
		}
	}
	if (type == 4) {
		ulong orderTicket = OrderTicket();
		
		if (HistoryOrderSelect(orderTicket)) {
			return HistoryOrderGetString(orderTicket, ORDER_SYMBOL);
		}
	}

	return OrderGetString(ORDER_SYMBOL);
}

double OrderTakeProfit()
{
	int type = LoadedType();

	if (type == 1) {return PositionGetDouble(POSITION_TP);}
	if (type == 3) {
		ulong dealTicket = OrderTicket();
		
		if (HistoryDealSelect(dealTicket)) {
			return HistoryDealGetDouble(dealTicket, DEAL_TP);
		}
	}
	if (type == 4) {
		ulong orderTicket = OrderTicket();
		
		if (HistoryOrderSelect(orderTicket)) {
			return HistoryOrderGetDouble(orderTicket, ORDER_TP);
		}
	}

	return OrderGetDouble(ORDER_TP);
}

long OrderTicket(long ticket = 0)
{
	static long memory = 0;

	if (ticket > 0) {memory = ticket;}

	return memory;
}

int OrderType()
{
	int type = LoadedType();

	if (type == 1) {return (int)PositionGetInteger(POSITION_TYPE);}
	if (type == 2) {return (int)OrderGetInteger(ORDER_TYPE);}
	if (type == 3)
	{
		ulong dealTicket = OrderTicket();
		int orderType = -1;

		if (HistoryDealSelect(dealTicket)) {
			long positionId = HistoryDealGetInteger(dealTicket, DEAL_POSITION_ID);

			HistorySelectByPosition(positionId);
	
			ulong firstDealTicket = HistoryDealGetTicket(0);

			orderType = (int)HistoryDealGetInteger(firstDealTicket, DEAL_TYPE);
		}

		HistoryTradesTotalReset();

		return orderType;
	}
	if (type == 4) {
		ulong orderTicket = OrderTicket();
		
		if (HistoryOrderSelect(orderTicket)) {
			return (int)HistoryOrderGetInteger(OrderTicket(),ORDER_TYPE);
		}
	}

	return (int)OrderGetInteger(ORDER_TYPE);
}

bool PendingOrderSelectByIndex(
	int index,
	string group_mode    = "all",
	string group         = "0",
	string market_mode   = "all",
	string market        = "",
	string BuysOrSells   = "both",
	string LimitsOrStops = "both"
)
{
	if (LoadPendingOrder(OrderGetTicket(index)))
	{
		if (FilterOrderBy(
			group_mode,
			group,
			market_mode,
			market,
			BuysOrSells,
			LimitsOrStops,
			1)
		) {
			return true;
		}
	}

	return false;
}

bool PendingOrderSelectByTicket(ulong ticket)
{
	bool success = OrderSelect(ticket);

	if (success) {
		LoadedType(2);
		OrderTicket(ticket);
	}

	return success;
}

double PipValue(string symbol)
{
	if (symbol == "") symbol = Symbol();

	return CustomPoint(symbol) / SymbolInfoDouble(symbol, SYMBOL_POINT);
}

bool PositionSelectByDeal(ulong dealTicket)
{
	bool success = false;

	if (HistoryDealSelect(dealTicket)) {
		long positionId = HistoryDealGetInteger(dealTicket, DEAL_POSITION_ID);
		
		if (positionId)
		{
			int total = PositionsTotal();
			
			for (int i = total - 1; i >= 0; i--)
			{
				if (PositionGetTicket(i))
				{
					if (PositionGetInteger(POSITION_IDENTIFIER) == positionId)
					{
						success = true;
	
						break;
					}
				}
			}
		}
	}

	return success;
}

int SecondsFromComponents(double days, double hours, double minutes, int seconds)
{
	int retval =
		86400 * (int)MathFloor(days)
		+ 3600 * (int)(MathFloor(hours) + (24 * (days - MathFloor(days))))
		+ 60 * (int)(MathFloor(minutes) + (60 * (hours - MathFloor(hours))))
		+ (int)((double)seconds + (60 * (minutes - MathFloor(minutes))));

	return retval;
}

datetime SelectedHistoryFromTime(datetime setTime = -1)
{
	static datetime time;
	
	if (setTime > -1)
	{
		time = setTime;
	}
	
	return time;
}

datetime SelectedHistoryToTime(datetime setTime = -1)
{
	static datetime time;
	
	if (setTime > -1)
	{
		time = setTime;
	}
	
	return time;
}

long SellLater(
	string symbol,
	double lots,
	double price,
	double sll = 0, // SL level
	double tpl = 0, // TP level
	double slp = 0, // SL adjust in points
	double tpp = 0, // TP adjust in points
	double slippage = 0,
	datetime expiration = 0,
	int magic = 0,
	string comment = "",
	color arrowcolor = clrNONE,
	bool oco = false
	)
{
	double bid = SymbolInfoDouble(symbol,SYMBOL_BID);
	ENUM_ORDER_TYPE type = 0;

	     if (price == bid) {type = ORDER_TYPE_SELL;}
	else if (price < bid)  {type = ORDER_TYPE_SELL_STOP;}
	else if (price > bid)  {type = ORDER_TYPE_SELL_LIMIT;}

	return OrderCreate(
		symbol,
		type,
		lots,
		price,
		sll,
		tpl,
		slp,
		tpp,
		slippage,
		magic,
		comment,
		arrowcolor,
		expiration,
		oco
	);
}

long SellNow(
	string symbol,
	double lots,
	double sll,
	double tpl,
	double slp,
	double tpp,
	double slippage = 0,
	int magic = 0,
	string comment = "",
	color arrowcolor = clrNONE,
	datetime expiration = 0
	)
{
	return OrderCreate(
		symbol,
		POSITION_TYPE_SELL,
		lots,
		0,
		sll,
		tpl,
		slp,
		tpp,
		slippage,
		magic,
		comment,
		arrowcolor,
		expiration
	);
}

bool SetFlagB(string flagname, bool flagvalue, string command="set")
{
	static string ids[];
	static bool memory[];

	int size;
	int i;
	int id = -1;

	size = ArraySize(ids);

	if (size > 0)
	{
		for (i = 0; i < size; i++)
		{
			if (ids[i] == flagname)
			{
				id = i;
				break;
			}
	}  }

	if (command == "set")
	{
		if (id > -1)
		{
			memory[id] = flagvalue;
			return memory[id];
		}

		if (flagname != "")
		{
			ArrayResize(ids,size+1);
			ArrayResize(memory,size+1);

			ids[size]    = flagname;
			memory[size] = flagvalue;
		}
	}
	else
	{
		if (id > -1)
		{
			return memory[id];
		}

		return false;
	}

	return false;
}

string SetFlagT(string flagname, string flagvalue, string command="set")
{
   static string ids[];
   static string memory[];
   int size;
   int i;
   int id=-1;
   
   size=ArraySize(ids);
   if (size>0) {
      for (i=0; i<size; i++) {
         if (ids[i]==flagname) {id=i; break;}
   }  }
   
   if (command=="set") {
      if (id>-1) {memory[id]=flagvalue; return(memory[id]);}
      if (flagname!="") {
         ArrayResize(ids,size+1);
         ArrayResize(memory,size+1);
         ids[size]=flagname;
         memory[size]=flagvalue;
      }
      
   }
   else {
      if (id>-1) {return(memory[id]);}
      return("");
   }
   return("");
}

bool SkipThePass(bool set=false)
{
   static int mem_fid=0;
   static bool mem=false;
   if (set==true) {
      mem=true;
      mem_fid=FXD_CURRENT_FUNCTION_ID;
   }
   else {
      if (mem_fid!=FXD_CURRENT_FUNCTION_ID) {
         mem=false; // reset
         return(false);
      }
      if (mem==true) {
         mem=false; // reset
         return(true);
      }
   }
   return(mem);
}

int StrToInteger(string value)
{
	return (int)StringToInteger(value);
}

template<typename T>
void StringExplode(string delimiter, string inputString, T &output[])
{
	int begin   = 0;
	int end     = 0;
	int element = 0;
	int length  = StringLen(inputString);
	int length_delimiter = StringLen(delimiter);
	T empty_val  = (typename(T) == "string") ? (T)"" : (T)0;

	if (length > 0)
	{
		while (true)
		{
			end = StringFind(inputString, delimiter, begin);

			ArrayResize(output, element + 1);
			output[element] = empty_val;
	
			if (end != -1)
			{
				if (end > begin)
				{
					output[element] = (T)StringSubstr(inputString, begin, end - begin);
				}
			}
			else
			{
				output[element] = (T)StringSubstr(inputString, begin, length - begin);
				break;
			}
			
			begin = end + 1 + (length_delimiter - 1);
			element++;
		}
	}
	else
	{
		ArrayResize(output, 1);
		output[element] = empty_val;
	}
}

template<typename T>
string StringImplode(string delimeter, T &array[])
{
   string retval = "";
	int size      = ArraySize(array);

   for (int i = 0; i < size; i++)
	{
      StringConcatenate(retval, retval, (string)array[i], delimeter);
   }

   return StringSubstr(retval, 0, (StringLen(retval) - StringLen(delimeter)));
}

datetime StringToTimeEx(string str, string mode="server")
{
	// mode: server, local, gmt
	int offset = 0;

	if (mode == "server") {offset = 0;}
	else if (mode == "local") {offset = (int)(TimeLocal() - TimeCurrent());}
	else if (mode == "gmt") {offset = (int)(TimeGMT() - TimeCurrent());}

	datetime time = StringToTime(str) - offset;

	return time;
}

string StringTrim(string text)
{
	StringTrimRight(text);
	StringTrimLeft(text);

	return text;
}

double SymbolAsk(string symbol)
{
	if (symbol == "") symbol = Symbol();

	return SymbolInfoDouble(symbol, SYMBOL_ASK);
}

double SymbolBid(string symbol)
{
	if (symbol == "") symbol = Symbol();

	return SymbolInfoDouble(symbol, SYMBOL_BID);
}

int SymbolDigits(string symbol)
{
	if (symbol == "") symbol = Symbol();

	return (int)SymbolInfoInteger(symbol, SYMBOL_DIGITS);
}

double SymbolLotSize(string symbol)
{
	if (symbol == "") symbol = Symbol();

	return SymbolInfoDouble(symbol, SYMBOL_TRADE_CONTRACT_SIZE);
}

double SymbolLotStep(string symbol)
{
	if (symbol == "") symbol = Symbol();

	return SymbolInfoDouble(symbol, SYMBOL_VOLUME_STEP);
}

double SymbolMaxLot(string symbol)
{
	if (symbol == "") symbol = Symbol();

	return SymbolInfoDouble(symbol, SYMBOL_VOLUME_MAX);
}

double SymbolMinLot(string symbol)
{
	if (symbol == "") symbol = Symbol();

	return SymbolInfoDouble(symbol, SYMBOL_VOLUME_MIN);
}

ENUM_TIMEFRAMES TFMigrate(int tf)
{
	switch (tf)
	{
		case 0: return PERIOD_CURRENT;
		case 1: return PERIOD_M1;
		case 5: return PERIOD_M5;
		case 15: return PERIOD_M15;
		case 30: return PERIOD_M30;
		case 60: return PERIOD_H1;
		case 240: return PERIOD_H4;
		case 1440: return PERIOD_D1;
		case 10080: return PERIOD_W1;
		case 43200: return PERIOD_MN1;

		case 2: return PERIOD_M2;
		case 3: return PERIOD_M3;
		case 4: return PERIOD_M4;      
		case 6: return PERIOD_M6;
		case 10: return PERIOD_M10;
		case 12: return PERIOD_M12;
		case 16385: return PERIOD_H1;
		case 16386: return PERIOD_H2;
		case 16387: return PERIOD_H3;
		case 16388: return PERIOD_H4;
		case 16390: return PERIOD_H6;
		case 16392: return PERIOD_H8;
		case 16396: return PERIOD_H12;
		case 16408: return PERIOD_D1;
		case 32769: return PERIOD_W1;
		case 49153: return PERIOD_MN1;

		default: return PERIOD_CURRENT;
	}
}

double TicksData(string symbol = "", int type = 0, int shift = 0)
{
	static bool collecting_ticks = false;
	static string symbols[];
	static int zero_sid[];
	static double memoryASK[][100];
	static double memoryBID[][100];

	int sid = 0, size = 0, i = 0, id = 0;
	double ask = 0, bid = 0, retval = 0;
	bool exists = false;

	if (ArraySize(symbols) == 0)
	{
		ArrayResize(symbols, 1);
		ArrayResize(zero_sid, 1);
		ArrayResize(memoryASK, 1);
		ArrayResize(memoryBID, 1);

		symbols[0] = _Symbol;
	}

	if (type > 0 && shift > 0)
	{
		collecting_ticks = true;
	}

	if (collecting_ticks == false)
	{
		if (type > 0 && shift == 0)
		{
			// going to get ticks
		}
		else
		{
			return 0;
		}
	}

	if (symbol == "") symbol = _Symbol;

	if (type == 0)
	{
		exists = false;
		size   = ArraySize(symbols);

		if (size == 0) {ArrayResize(symbols, 1);}

		for (i=0; i<size; i++)
		{
			if (symbols[i] == symbol)
			{
				exists = true;
				sid    = i;
				break;
			}
		}

		if (exists == false)
		{
			int newsize = ArraySize(symbols) + 1;

			ArrayResize(symbols, newsize);
			symbols[newsize-1] = symbol;

			ArrayResize(zero_sid, newsize);
			ArrayResize(memoryASK, newsize);
			ArrayResize(memoryBID, newsize);

			sid=newsize;
		}

		if (sid >= 0)
		{
			ask = SymbolInfoDouble(symbol, SYMBOL_ASK);
			bid = SymbolInfoDouble(symbol, SYMBOL_BID);

			if (bid == 0 && MQLInfoInteger(MQL_TESTER))
			{
				Print("Ticks data collector error: " + symbol + " cannot be backtested. Only the current symbol can be backtested. The EA will be terminated.");
				ExpertRemove();
			}

			if (
				   symbol == _Symbol
				|| ask != memoryASK[sid][0]
				|| bid != memoryBID[sid][0]
			)
			{
				memoryASK[sid][zero_sid[sid]] = ask;
				memoryBID[sid][zero_sid[sid]] = bid;
				zero_sid[sid]                 = zero_sid[sid] + 1;

				if (zero_sid[sid] == 100)
				{
					zero_sid[sid] = 0;
				}
			}
		}
	}
	else
	{
		if (shift <= 0)
		{
			if (type == SYMBOL_ASK)
			{
				return SymbolInfoDouble(symbol, SYMBOL_ASK);
			}
			else if (type == SYMBOL_BID)
			{
				return SymbolInfoDouble(symbol, SYMBOL_BID); 
			}
			else
			{
				double mid = ((SymbolInfoDouble(symbol, SYMBOL_ASK) + SymbolInfoDouble(symbol, SYMBOL_BID)) / 2);

				return mid;
			}
		}
		else
		{
			size = ArraySize(symbols);

			for (i = 0; i < size; i++)
			{
				if (symbols[i] == symbol)
				{
					sid = i;
				}
			}

			if (shift < 100)
			{
				id = zero_sid[sid] - shift - 1;

				if(id < 0) {id = id + 100;}

				if (type == SYMBOL_ASK)
				{
					retval = memoryASK[sid][id];

					if (retval == 0)
					{
						retval = SymbolInfoDouble(symbol, SYMBOL_ASK);
					}
				}
				else if (type == SYMBOL_BID)
				{
					retval = memoryBID[sid][id];

					if (retval == 0)
					{
						retval = SymbolInfoDouble(symbol, SYMBOL_BID);
					}
				}
			}
		}
	}

	return retval;
}

int TicksPerSecond(bool get_max = false, bool set = false)
{
	static datetime time0 = 0;
	static int ticks      = 0;
	static int tps        = 0;
	static int tpsmax     = 0;

	datetime time1 = TimeLocal();

	if (set == true)
	{
		if (time1 > time0)
		{
			if (time1 - time0 > 1)
			{
				tps = 0;
			}
			else
			{
				tps = ticks;
			}

			time0 = time1;
			ticks = 0;
		}

		ticks++;

		if (tps > tpsmax) {tpsmax = tps;}
	}

	if (get_max)
	{
		return tpsmax;
	}

	return tps;
}

datetime TimeAtStart(string cmd = "server")
{
	static datetime local  = 0;
	static datetime server = 0;

	if (cmd == "local")
	{
		return local;
	}
	else if (cmd == "server")
	{
		return server;
	}
	else if (cmd == "set")
	{
		local  = TimeLocal();
		server = TimeCurrent();
	}

	return 0;
}

int TimeDay(datetime time)
{
	MqlDateTime tm;
   TimeToStruct(time,tm);
   return(tm.day);
}

int TimeDayOfWeek(datetime time)
{
   MqlDateTime tm;
   TimeToStruct(time,tm);
   return(tm.day_of_week);
}

datetime TimeFromComponents(
	int time_src = 0,
	int    y = 0,
	int    m = 0,
	double d = 0,
	double h = 0,
	double i = 0,
	int    s = 0
) {
	MqlDateTime tm;
	int offset = 0;

	if (time_src == 0) {
		TimeCurrent(tm);
	}
	else if (time_src == 1) {
		TimeLocal(tm); 
		offset = (int)(TimeLocal() - TimeCurrent());
	}
	else if (time_src == 2) {
		TimeGMT(tm);
		offset = (int)(TimeGMT() - TimeCurrent());
	}

	if (y > 0)
	{
		if (y < 100) {y = 2000 + y;}
		tm.year = y;
	}
	if (m > 0) {tm.mon = m;}
	if (d > 0) {tm.day = (int)MathFloor(d);}

	tm.hour = (int)(MathFloor(h) + (24 * (d - MathFloor(d))));
	tm.min  = (int)(MathFloor(i) + (60 * (h - MathFloor(h))));
	tm.sec  = (int)((double)s + (60 * (i - MathFloor(i))));
	
	datetime time = StructToTime(tm) - offset;

	return time;
}

int TimeHour(datetime time)
{
	MqlDateTime tm;
	TimeToStruct(time,tm);

	return tm.hour;
}

int TimeMinute(datetime time)
{
	MqlDateTime tm;
	TimeToStruct(time,tm);
	
	return tm.min;
}

int TimeMonth(datetime time)
{
	MqlDateTime tm;
	TimeToStruct(time,tm);

	return tm.mon;
}

int TimeSeconds(datetime time)
{
	MqlDateTime tm;
	TimeToStruct(time,tm);

	return tm.sec;
}

int TimeYear(datetime time)
{
   MqlDateTime tm;
	TimeToStruct(time,tm);

	return tm.year;
}

bool TradeSelectByIndex(
	int index,
	string group_mode    = "all",
	string group         = "0",
	string market_mode   = "all",
	string market        = "",
	string BuysOrSells   = "both"
) {
	if (LoadPosition(PositionGetTicket(index)))
	{
		if (FilterOrderBy(
			group_mode,
			group,
			market_mode,
			market,
			BuysOrSells)
			)
		{
			return true;
		}
	}

	return false;
}

bool TradeSelectByTicket(ulong ticket)
{
	if (LoadPosition(ticket) && OrderType() < 2)
	{
		return true;
	}

	return false;
}

int TradesTotal()
{
	return PositionsTotal();
}

double VirtualStopsDriver(
	string command = "",
	ulong ti       = 0,
	double sl      = 0,
	double tp      = 0,
	double slp     = 0,
	double tpp     = 0
)
{
	static bool initialized     = false;
	static string name          = "";
	static string loop_name[2]  = {"sl", "tp"};
	static color  loop_color[2] = {DeepPink, DodgerBlue};
	static double loop_price[2] = {0, 0};
	static ulong mem_to_ti[]; // tickets
	static int mem_to[];      // timeouts
	static bool trade_pass = false;
	int i = 0;

	// Are Virtual Stops even enabled?
	if (!USE_VIRTUAL_STOPS)
	{
		return 0;
	}
	
	if (initialized == false || command == "initialize")
	{
		initialized = true;
	}

	// Listen
	if (command == "" || command == "listen")
	{
		int total     = ObjectsTotal(0, -1, OBJ_HLINE);
		int length    = 0;
		color clr     = clrNONE;
		int sltp      = 0;
		ulong ticket  = 0;
		double level  = 0;
		double askbid = 0;
		int polarity  = 0;
		string symbol = "";

		for (i = total - 1; i >= 0; i--)
		{
			name = ObjectName(0, i, -1, OBJ_HLINE); // for example: #1 sl

			if (StringSubstr(name, 0, 1) != "#")
			{
				continue;
			}

			length = StringLen(name);

			if (length < 5)
			{
				continue;
			}

			clr = (color)ObjectGetInteger(0, name, OBJPROP_COLOR);

			if (clr != loop_color[0] && clr != loop_color[1])
			{
				continue;
			}

			string last_symbols = StringSubstr(name, length-2, 2);

			if (last_symbols == "sl")
			{
				sltp = -1;
			}
			else if (last_symbols == "tp")
			{
				sltp = 1;
			}
			else
			{
				continue;	
			}

			ulong ticket0 = StringToInteger(StringSubstr(name, 1, length - 4));

			// prevent loading the same ticket number twice in a row
			if (ticket0 != ticket)
			{
				ticket = ticket0;

				if (TradeSelectByTicket(ticket))
				{
					symbol     = OrderSymbol();
					polarity   = (OrderType() == 0) ? 1 : -1;
					askbid   = (OrderType() == 0) ? SymbolInfoDouble(symbol, SYMBOL_BID) : SymbolInfoDouble(symbol, SYMBOL_ASK);
					
					trade_pass = true;
				}
				else
				{
					trade_pass = false;
				}
			}

			if (trade_pass)
			{
				level    = ObjectGetDouble(0, name, OBJPROP_PRICE, 0);

				if (level > 0)
				{
					// polarize levels
					double level_p  = polarity * level;
					double askbid_p = polarity * askbid;

					if (
						   (sltp == -1 && (level_p - askbid_p) >= 0) // sl
						|| (sltp == 1 && (askbid_p - level_p) >= 0)  // tp
					)
					{
						//-- Virtual Stops SL Timeout
						if (
							   (VIRTUAL_STOPS_TIMEOUT > 0)
							&& (sltp == -1 && (level_p - askbid_p) >= 0) // sl
						)
						{
							// start timeout?
							int index = ArraySearch(mem_to_ti, ticket);

							if (index < 0)
							{
								int size = ArraySize(mem_to_ti);
								ArrayResize(mem_to_ti, size+1);
								ArrayResize(mem_to, size+1);
								mem_to_ti[size] = ticket;
								mem_to[size]    = (int)TimeLocal();

								Print(
									"#",
									ticket,
									" timeout of ",
									VIRTUAL_STOPS_TIMEOUT,
									" seconds started"
								);

								return 0;
							}
							else
							{
								if (TimeLocal() - mem_to[index] <= VIRTUAL_STOPS_TIMEOUT)
								{
									return 0;
								}
							}
						}

						if (CloseTrade(ticket))
						{
							// check this before deleting the lines
							//OnTradeListener();

							// delete objects
							ObjectDelete(0, "#" + (string)ticket + " sl");
							ObjectDelete(0, "#" + (string)ticket + " tp");
						}
					}
					else
					{
						if (VIRTUAL_STOPS_TIMEOUT > 0)
						{
							i = ArraySearch(mem_to_ti, ticket);

							if (i >= 0)
							{
								ArrayStripKey(mem_to_ti, i);
								ArrayStripKey(mem_to, i);
							}
						}
					}
				}
			}
			else if (
					!PendingOrderSelectByTicket(ticket)
				|| OrderCloseTime() > 0 // in case the order has been closed
			)
			{
				ObjectDelete(0, name);
			}
			else
			{
				PendingOrderSelectByTicket(ticket);
			}
		}
	}
	// Get SL or TP
	else if (
		ti > 0
		&& (
			   command == "get sl"
			|| command == "get tp"
		)
	)
	{
		double value = 0;

		name = "#" + IntegerToString(ti) + " " + StringSubstr(command, 4, 2);

		if (ObjectFind(0, name) > -1)
		{
			value = ObjectGetDouble(0, name, OBJPROP_PRICE, 0);
		}

		return value;
	}
	// Set SL and TP
	else if (
		ti > 0
		&& (
			   command == "set"
			|| command == "modify"
			|| command == "clear"
			|| command == "partial"
		)
	)
	{
		loop_price[0] = sl;
		loop_price[1] = tp;

		for (i = 0; i < 2; i++)
		{
			name = "#" + IntegerToString(ti) + " " + loop_name[i];
			
			if (loop_price[i] > 0)
			{
				// 1) create a new line
				if (ObjectFind(0, name) == -1)
				{
						 ObjectCreate(0, name, OBJ_HLINE, 0, 0, loop_price[i]);
					ObjectSetInteger(0, name, OBJPROP_WIDTH, 1);
					ObjectSetInteger(0, name, OBJPROP_COLOR, loop_color[i]);
					ObjectSetInteger(0, name, OBJPROP_STYLE, STYLE_DOT);
					ObjectSetString(0, name, OBJPROP_TEXT, name + " (virtual)");
				}
				// 2) modify existing line
				else
				{
					ObjectSetDouble(0, name, OBJPROP_PRICE, 0, loop_price[i]);
				}
			}
			else
			{
				// 3) delete existing line
				ObjectDelete(0, name);
			}
		}

		// print message
		if (command == "set" || command == "modify")
		{
			Print(
				command,
				" #",
				IntegerToString(ti),
				": virtual sl ",
				DoubleToStr(sl, (int)SymbolInfoInteger(Symbol(),SYMBOL_DIGITS)),
				" tp ",
				DoubleToStr(tp,(int)SymbolInfoInteger(Symbol(),SYMBOL_DIGITS))
			);
		}

		return 1;
	}

	return 1;
}

int WindowFindVisible(long chart_id, string term)
{
   //-- the search term can be chart name, such as Force(13), or subwindow index
   if (term == "" || term == "0") {return 0;}
   
   int subwindow = (int)StringToInteger(term);
   
   if (subwindow == 0 && StringLen(term) > 1)
   {
      subwindow = ChartWindowFind(chart_id, term);
   }
   
   if (subwindow > 0 && !ChartGetInteger(chart_id, CHART_WINDOW_IS_VISIBLE, subwindow))
   {
      return -1;  
   }
   
   return subwindow;
}

double ask(string symbol = NULL)
{
	return SymbolInfoDouble(symbol, SYMBOL_ASK);
}

// The lots closed when partially closing a trade
double attrLotsClosed(double lots=-1)
{
	static double mem=0;
   if (lots>=0) {mem=lots;}
   return(mem);
}

double attrLotsInitial()
{
	double retval = 0.0;
	ulong ticket = OrderTicket();

	long parentTicket = attrTicketParent(ticket);

	if (HistorySelectByPosition(parentTicket)) {
		int total = HistoryDealsTotal();

		if (total > 0) {
			long dealTicket = (long)HistoryDealGetTicket(0);

			retval = HistoryDealGetDouble(dealTicket, DEAL_VOLUME);
		}
	}

	HistoryTradesTotalReset();
	PositionSelectByTicket(ticket);

   return retval;
}

double attrLotsInitial(string symbol) {
	double retval = 0.0;

   if (!PositionSelect(symbol)) {
   	return 0.0;
   }
  
   long positionId = PositionGetInteger(POSITION_IDENTIFIER);
   
   if (HistorySelectByPosition(positionId)) {
		int total = HistoryDealsTotal();

		if (total > 0) {
			long ticket = (long)HistoryDealGetTicket(0);
			
			retval = HistoryDealGetDouble(ticket, DEAL_VOLUME);
		}
	}

	HistoryTradesTotalReset();

   return retval;
}

double attrStopLoss()
{
	if (USE_VIRTUAL_STOPS)
	{
		return VirtualStopsDriver("get sl", OrderTicket());
	}

	return OrderStopLoss();
}

double attrTakeProfit()
{
	if (USE_VIRTUAL_STOPS)
	{
		return VirtualStopsDriver("get tp", OrderTicket());
	}

   return OrderTakeProfit();
}

long attrTicketInLoop(long ticket = 0)
{
	static long t;

	if (ticket > 0) {t = ticket;}

	return t;
}

/**
* Get the parent position ticket when the current position
* was created as "add to volume" child.
* In other cases, return the input ticket.
*/
long attrTicketParent(long ticket)
{
	long parentTicket = 0;

	if (PositionSelectByTicket(ticket)) {
		string comment = PositionGetString(POSITION_COMMENT);
		int tagPos     = StringFind(comment, "[p=");
		
		if (tagPos >= 0) {
			string tag   = StringSubstr(comment, tagPos);
			tag          = StringSubstr(tag, 0, StringFind(tag, "]") + 1);
			parentTicket = StringToInteger(StringSubstr(tag, 3, -1));
		}
	}

	if (parentTicket == 0) {
		parentTicket = ticket;
	}

	return parentTicket;
}

int attrTypeInLoop(int type=0)
{
	static int t;

	if (type > 0) {t = type;}

	return t;
}

string e_Reason() {return onTradeEventDetector.EventValueReason();}

string e_ReasonDetail() {return onTradeEventDetector.EventValueDetail();}

double e_attrClosePrice() {return onTradeEventDetector.EventValuePriceClose();}

datetime e_attrCloseTime() {return onTradeEventDetector.EventValueTimeClose();}

string e_attrComment() {return onTradeEventDetector.EventValueComment();}

datetime e_attrExpiration() {return onTradeEventDetector.EventValueTimeExpiration();}

double e_attrLots() {return onTradeEventDetector.EventValueVolume();}

long e_attrMagicNumber() {return onTradeEventDetector.EventValueMagic();}

double e_attrOpenPrice() {return onTradeEventDetector.EventValuePriceOpen();}

datetime e_attrOpenTime() {return onTradeEventDetector.EventValueTimeOpen();}

double e_attrProfit() {return onTradeEventDetector.EventValueProfit();}

double e_attrStopLoss() {return onTradeEventDetector.EventValueStopLoss();}

double e_attrSwap() {return onTradeEventDetector.EventValueSwap();}

string e_attrSymbol() {return onTradeEventDetector.EventValueSymbol();}

double e_attrTakeProfit() {return onTradeEventDetector.EventValueTakeProfit();}

long e_attrTicket() {return onTradeEventDetector.EventValueTicket();}

int e_attrType() {return onTradeEventDetector.EventValueType();}

template<typename DT1, typename DT2>
double formula(string sign, DT1 v1, DT2 v2)
{
	     if (sign == "+") return(v1 + v2);
	else if (sign == "-") return(v1 - v2);
	else if (sign == "*") return(v1 * v2);
	else if (sign == "/") return(v1 / v2);

	return false;
}

string formula(string sign, string v1, string v2)
{
	if (sign == "+") return(v1 + v2);
	else {
		double _v1 = StringToDouble(v1);
		double _v2 = StringToDouble(v2);
		
		     if (sign == "-") return DoubleToString(_v1 - _v2);
		else if (sign == "*") return DoubleToString(_v1 * _v2);
		else if (sign == "/") return DoubleToString(_v1 / _v2);
	}

	return v1 + v2;
}

double formula(string sign, string v1, double v2)
{
	     if (sign == "+") return StringToDouble(v1) + v2;
	else if (sign == "-") return StringToDouble(v1) - v2;
	else if (sign == "*") return StringToDouble(v1) * v2;
	else if (sign == "/") return StringToDouble(v1) / v2;

	return StringToDouble(v1) + v2;
}

double formula(string sign, double v1, string v2)
{
	if (sign == "+") return (v1 + StringToDouble(v2));
	else if (sign == "-") return v1 - StringToDouble(v2);
	else if (sign == "*") return v1 * StringToDouble(v2);
	else if (sign == "/") return v1 / StringToDouble(v2);

	return v1 + StringToDouble(v2);
}

int iCandleID(string SYMBOL, ENUM_TIMEFRAMES TIMEFRAME, datetime time_stamp)
{
	bool TimeStampPrevDayShift = true;
	int CandleID               = 0;

	// get the time resolution of the desired period, in minutes
	int mins_tf  = TIMEFRAME;
	int mins_tf0 = 0;

	if (TIMEFRAME == PERIOD_CURRENT)
	{
		mins_tf = (int)PeriodSeconds(PERIOD_CURRENT) / 60;
	}

	// get the difference between now and the time we want, in minutes
	int days_adjust = 0;

	if (TimeStampPrevDayShift)
	{
		// automatically shift to the previous day
		if (time_stamp > TimeCurrent())
		{
			time_stamp = time_stamp - 86400;
		}

		// also shift weekdays
		while (true)
		{
			int dow = TimeDayOfWeek(time_stamp);

			if (dow > 0 && dow < 6) {break;}

			time_stamp = time_stamp - 86400;
			days_adjust++;
		}
	}

	int mins_diff = (int)(TimeCurrent() - time_stamp);
	mins_diff = mins_diff - days_adjust*86400;
	mins_diff = mins_diff / 60;

	// the difference is negative => quit here
	if (mins_diff < 0)
	{
		return (int)EMPTY_VALUE;
	}

	// now calculate the candle ID, it is relative to the current time
	if (mins_diff > 0)
	{
		CandleID = (int)MathCeil((double)mins_diff/(double)mins_tf);
	}

	// now, after all the shifting and in case of missing candles, the calculated candle id can be few candles early
	// so we will search for the right candle
	while(true)
	{
		if (iTime(SYMBOL, TIMEFRAME, CandleID) >= time_stamp) {break;}

		CandleID--;

		if (CandleID <= 0) {CandleID = 0; break;}
	}

	return CandleID;
}

double toDigits(double pips, string symbol)
{
	if (symbol == "") symbol = Symbol();

	int digits   = (int)SymbolInfoInteger(symbol, SYMBOL_DIGITS);
	double point = SymbolInfoDouble(symbol, SYMBOL_POINT);

	return NormalizeDouble(pips * PipValue(symbol) * point, digits);
}

double toPips(double digits, string symbol)
{
	if (symbol == "") symbol = Symbol();

   return digits / (PipValue(symbol) * SymbolInfoDouble(symbol, SYMBOL_POINT));
}






class FxdWaiting
{
	private:
		int beginning_id;
		ushort bank  [][2][20]; // 2 banks, 20 possible parallel waiting blocks per chain of blocks
		ushort state [][2];     // second dimention values: 0 - count of the blocks put on hold, 1 - current bank id

	public:
		void Initialize(int count)
		{
			ArrayResize(bank, count);
			ArrayResize(state, count);
		}

		bool Run(int id = 0)
		{
			beginning_id = id;

			int range = ArrayRange(state, 0);
			if (range < id+1) {
				ArrayResize(bank, id+1);
				ArrayResize(state, id+1);

				// set values to 0, otherwise they have random values
				for (int ii = range; ii < id+1; ii++)
				{
				   state[ii][0] = 0;
				   state[ii][1] = 0;
				}
			}

			// are there blocks put on hold?
			int count = state[id][0];
			int bank_id = state[id][1];

			// if no block are put on hold -> escape
			if (count == 0) {return false;}
			else
			{
				state[id][0] = 0; // null the count
				state[id][1] = (bank_id) ? 0 : 1; // switch to the other bank
			}

			//== now we will run the blocks put on hold

			for (int i = 0; i < count; i++)
			{
				int block_to_run = bank[id][bank_id][i];
				_blocks_[block_to_run].run();
			}

			return true;
		}

		void Accumulate(int block_id = 0)
		{
			int count   = ++state[beginning_id][0];
			int bank_id = state[beginning_id][1];

			bank[beginning_id][bank_id][count-1] = (ushort)block_id;
		}
};
FxdWaiting fxdWait;



//+------------------------------------------------------------------+
//| END                                                              |
//| Created with fxDreema EA Builder           https://fxdreema.com/ |
//+------------------------------------------------------------------+

/*<fxdreema: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
:fxdreema>*/
