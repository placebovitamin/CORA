function res = testLongDuration_matZonotope_norm
% testLongDuration_matZonotope_norm - unit test function of norm; the result is
% compared to the norm of all vertices
% 
% Syntax:  
%    res = testLongDuration_matZonotope_norm
%
% Inputs:
%    -
%
% Outputs:
%    res - true/false
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: -

% Author:       Matthias Althoff
% Written:      02-November-2017
% Last update:  ---
% Last revision:---

%------------- BEGIN CODE --------------

% create interval matrix
% center
matrixCenter = [ ...
0.1030783856804509, -0.9101278715321481, 0.6053092778292544, -0.7608595779453735, -0.2653784107456929, 0.8833290280791213, -0.5867093811050932, -0.3920964615009785, -0.9330031960700655, 0.2224896347355838; ...
-0.3358623384378412, -0.6606199258835557, 0.3453023581373951, 0.3373340161562055, 0.1728220584061801, 0.0571996064779656, -0.3622320218412414, -0.6610674364129314, 0.8292507232278290, -0.6361200702133358; ...
0.7258992470204615, 0.2226582101541923, 0.4569764282907689, -0.8375957540168222, 0.9482367162906631, 0.5867543962581900, 0.8899927549727960, -0.0438826364149949, -0.0382136940774347, 0.4472851749922520; ...
-0.3046165455476422, 0.9005982283328562, -0.6360513364531990, 0.4124682114261358, -0.8080476776070364, -0.5728913883303508, -0.5916024282199834, -0.5937651381699391, 0.6597700848648822, -0.0758241326363369; ...
0.7096807070659510, 0.4998074647484749, 0.9713758502353100, 0.9376564546258963, 0.2457649012001917, 0.8577861212555120, 0.5407432738095963, 0.4696139508867379, 0.2178340806678498, 0.6784418775414429; ...
-0.7440856538867173, -0.5786954854131867, -0.7372557698893745, 0.6013975816933068, -0.7329906793875653, -0.6534173712962281, 0.8794343222311480, -0.8762545300911007, -0.9999624970157370, -0.8504824917103764; ...
0.9084850705727758, -0.8989100454650638, 0.9920886519204546, 0.9198930027855210, 0.1288885207530313, 0.3430266672898845, 0.0650526293251279, 0.9152025750401234, -0.2713856840944358, -0.2328442840941238; ...
-0.5748584958454852, 0.7413066606288192, -0.3728964105823804, -0.4680697157913984, 0.1567639105156624, 0.0153859735195778, 0.3410331006983629, 0.1066855250868497, 0.3867543050330005, 0.1620966903388332; ...
0.8838491015893175, 0.9233098306708436, -0.9715289785483805, -0.6531267294643079, 0.5304519869096429, -0.5966071048661272, 0.8169855310441498, -0.5101349852246480, 0.5764394251020426, 0.5059990141202664; ...
-0.2456725263694224, -0.9851975999597997, -0.1965669055496231, 0.4875990931423375, 0.7099594112562833, -0.2178327228088248, -0.2044138432022624, 0.0436619915851515, -0.5099717870717175, 0.4996095777778413];

% generator 1
G{1} = [ ...
0.3751207667608223, -0.2349336009150442, -0.7114373156136358, -0.0580297417046427, -0.6875042580158681, -0.6888486679279389, 0.2898714179410671, -0.9432795972096502, -0.0744770228233731, -0.3963969063670916; ...
0.9331880749809554, 0.1355905388370493, 0.4838847359375154, -0.3342096240982033, 0.2741229250281747, 0.2297590596236823, 0.8191398259446245, 0.8837717870885617, -0.5039016392307831, 0.8107585470622514; ...
-0.7455565709123813, -0.1245963657239815, 0.8256547839760635, 0.7972918918651206, -0.4663638009902955, 0.1544071007075494, 0.4389437518529968, -0.2634678486265958, 0.4327498507690415, -0.9828520365303051; ...
-0.2769199850635151, -0.8996598433302581, 0.7604815768228936, 0.7645414388534642, -0.0569280774274030, 0.5458701694220485, -0.0310482287289708, -0.6618155490120483, -0.7304297863386380, -0.5005923658155174; ...
0.9920766192928832, 0.5215662166008941, -0.2929182386406333, 0.7079880837383690, -0.7735794896756001, -0.3082773955514337, 0.0621397979540532, -0.5505736368355505, -0.8410189658240854, -0.8198939683656246; ...
0.3860881845498279, 0.2542717222750639, 0.3572289387234904, 0.8730971642753758, 0.5564179007277741, 0.4076247420165973, 0.2434429301452767, 0.9344061714082892, 0.8477000970613400, 0.1171450667758223; ...
0.4057697372477231, 0.2462132765349827, 0.9914145978660249, -0.9380325051045260, 0.4244674376721900, -0.5639726778588379, -0.6144158462040752, -0.1228217217497798, -0.9105674333380869, 0.8831378867707247; ...
-0.6990635930836684, 0.2036635255878141, -0.4756884053950827, -0.4454674039544488, 0.5530889077827099, 0.2735185993178468, 0.5563054687550690, -0.2159551627905312, -0.4648200795383441, -0.4668460112190254; ...
-0.8296006612129700, -0.0170496509199638, -0.7850525937103894, 0.6328021784933340, 0.9314641203938441, -0.7505545889636518, -0.4079744248915713, 0.2879091025995013, -0.6669359444094343, 0.5006304092185188; ...
0.9214237728662329, -0.6681325456884544, -0.8830816306080265, -0.7804084142981342, 0.5600326808340590, -0.9978908648229325, 0.3673553292739666, 0.7261916885374695, 0.1550107415038009, -0.4856084402282732];

% generator 2
G{2} = [ ...
0.9297770703985531, 0.9189848527858060, -0.6576266243768765, -0.9311078389941825, 0.5093733639647218, -0.5523761210177260, -0.4849834917525271, -0.0534223021945415, 0.1356432814504422, -0.3257547112022370; ...
-0.6847738366449034, 0.3114813983131737, 0.4120921760392176, -0.1225112806872035, -0.4479498460028433, 0.5025341186113057, 0.6814345119673251, -0.2966809858740065, -0.8482914208738728, -0.6756353836135145; ...
0.9411855635212314, -0.9285766428516209, -0.9363343072451586, -0.2368830858139832, 0.3594053537073496, -0.4898097690814618, -0.4914356420569379, 0.6616572557925817, -0.8920997626667857, 0.5885690813678139; ...
0.9143338964858911, 0.6982586117375542, -0.4461540300782201, 0.5310335762980047, 0.3101960079476813, 0.0119141033302848, 0.6285696521376327, 0.1705281823054485, 0.0615951060179454, -0.3775699159103902; ...
-0.0292487025543176, 0.8679864955151011, -0.9076572187376921, 0.5903998022741264, -0.6747765296107389, 0.3981534453133719, -0.5129500625500214, 0.0994472165822791, 0.5583344602040223, 0.0570662710124255; ...
0.6005609377776002, 0.3574703097155469, -0.8057364375283049, -0.6262547908912428, -0.7620046368832467, 0.7818065050715970, 0.8585272463744555, 0.8343873276596201, 0.8680213684583660, -0.6687025410004381; ...
-0.7162273227455693, 0.5154802611566669, 0.6469156566545853, -0.0204712084235379, -0.0032718960357141, 0.9185828504108886, -0.3000324680303825, -0.4283219623592529, -0.7401875830525397, 0.2039638828032730; ...
-0.1564774347474500, 0.4862649362498324, 0.3896572459516341, -0.1088275985782010, 0.9194879170321621, 0.0944310599276061, -0.6068094991375836, 0.5144004582214425, 0.1376473217443854, -0.4740574309197114; ...
0.8314710503781342, -0.2155459609316637, -0.3658010398782789, 0.2926260202225293, -0.3192285466677336, -0.7227511143426417, -0.4978322840479379, 0.5074581885569907, -0.0612187178835883, 0.3081581969535645; ...
0.5844146591191088, 0.3109557803551133, 0.9004440976767099, 0.4187296617161451, 0.1705355019595547, -0.7014119888818851, 0.2320893522932783, -0.2391083060492867, -0.9761958609975172, 0.3784290062800155];

% generator 3
G{3} = [ ...
0.4963031856474189, -0.1146434604491073, 0.6001369604486151, -0.7100904035525464, -0.5200949486701945, -0.7775944894124251, -0.8804409141056884, -0.0981525871381101, -0.8377484622684295, 0.5896628337669061; ...
-0.0989168029950045, -0.7866944596388312, -0.1371723450729108, 0.7060622354437873, -0.1654658618312610, 0.5605041366422758, -0.5304401732551873, 0.0940177845726899, 0.8587719419374600, 0.2886362603873833; ...
-0.8323572440061349, 0.9237961617101074, 0.8212951888590458, 0.2441102629701319, -0.9006911393485157, -0.2205223260774931, -0.2936828575558579, -0.4073583887844536, 0.5514253572168046, -0.2427812346794631; ...
-0.5420460625663623, -0.9907315517318651, -0.6363059433942950, -0.2980952382154582, 0.8054322198305621, -0.5166174281723346, 0.6423880803959181, 0.4893856141483124, -0.0264167351936553, 0.6231609165649543; ...
0.8266747230033391, 0.5498209294230048, -0.4723941669560199, 0.0264990797341067, 0.8895743794432920, -0.1921757088237706, -0.9691931246968899, -0.6220899699349109, -0.1282828228381618, 0.0656511775989097; ...
-0.6952439620615540, 0.6346064413068659, -0.7089220392305660, -0.1963839324961165, -0.0182718150638401, -0.8070909496632228, -0.9139523966843843, 0.3735508667306300, -0.1064325011403875, -0.2985457928462334; ...
0.6516339549790948, 0.7373894107270194, -0.7278628825826725, -0.8480666166183162, -0.0214947231999623, -0.7360534147873299, -0.6620199410745913, -0.6329776885254605, -0.3873010559668852, 0.8780031239997736; ...
0.0766848705201142, -0.8311283089781794, 0.7385844152801786, -0.5201676928926839, -0.3245611803572457, 0.8841011815509703, 0.2982309499129041, -0.2630308070193270, 0.0170173107622540, 0.7518856229859676; ...
0.9922694332537709, -0.2004347018022070, 0.1594091747311404, -0.7533621303296689, 0.8001076928353239, 0.9122690804596045, 0.4634447713173406, 0.2512371214593807, 0.0215431283442193, 0.1003126857968444; ...
-0.8436489424936326, -0.4802591942986916, 0.0997204036726640, -0.6321844234351666, -0.2615064377595699, 0.1504171901569311, 0.2954919262726134, 0.5604548703027536, 0.6352554166445241, 0.2449501720024549];

% instantiate matrix zonotope
M_zono = matZonotope(matrixCenter, G);

% obtain result of all vertices-------------------------
V = vertices(M_zono);

%loop through vertices
n_1_sample = zeros(length(V),1);
n_inf_sample = n_1_sample;
for i=1:length(V)
    n_1_sample(i) = norm(V{i}, 1);
    n_inf_sample(i) = norm(V{i}, inf);
end
%-------------------------------------------------------

% obtain results
n_1 = norm(M_zono, 1);
n_inf = norm(M_zono, inf);

%check if slightly bloated results enclose others
res_1 = all(n_1_sample <= n_1*1+1e-8);
res_2 = all(n_inf_sample <= n_inf*1+1e-8);

%result of different computation techniques
res = res_1 && res_2;

%------------- END OF CODE --------------