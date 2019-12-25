
%% Start of Program
clc
clear
w=[];
tic
fismat=readfis('FGA');
%% Algorithm Parameters
SelMethod = 1;
CrossMethod = 1;

PopSize = 100;
MaxIteration = 1000;

CrossPercent = 70;
MutatPercent = 20;
ElitPercent = 100 - CrossPercent - MutatPercent;

CrossNum = round(CrossPercent/100*PopSize); 

if mod(CrossNum,2)~=0; % makes sure that the number of crossover chromosomes is even
    CrossNum = CrossNum - 1; 
end

MutatNum = round(MutatPercent/100*PopSize);
ElitNum = PopSize - CrossNum - MutatNum;

%% Problem Satement
VarMin = -100;
VarMax = 100;
DimNum = 30;
CostFuncName = @Cost_func; %select the cost function i.e. the function to be optimized

%% Initial Population
Pop = rand(PopSize,DimNum) * (VarMax - VarMin) + VarMin;  %creates initial random population of chromosomes of size 30 between 100 and -100
Cost = feval(CostFuncName,Pop);%evaluates cost for each member of population
[Cost Indx] = sort(Cost); %sorts cost in ascending order and returns the list of corresponding indices
Pop = Pop(Indx,:); %arranges the population according in increasing order of their cost

%% Main Loop
MeanMat = [];
it=0;
for Iter = 1:MaxIteration
    %% Elitism
    ElitPop = Pop(1:ElitNum,:); %selects the elite population as we are min the initial ElitNum elements of pop are selected
    
    %% Cross Over
    CrossPop = [];
    ParentIndexes = SelectParents(Cost,CrossNum,SelMethod);%randomly selects indexes to be used for crossover
    
    for ii = 1:CrossNum/2
        Par1Indx = ParentIndexes(ii*2-1);
        Par2Indx = ParentIndexes(ii*2);
        
        Par1 = Pop(Par1Indx,:);
        Par2 = Pop(Par2Indx,:);
        
        [Off1 Off2] = Crossover(Par1,Par2,CrossMethod);%creates two offsprings by combining some random percent of parent 1 and parent 2
        CrossPop = [CrossPop ; Off1 ; Off2];
    end
    
    %% Mutation
    MutatPop = rand(MutatNum,DimNum) * (VarMax - VarMin) + VarMin;%creates mutation by creating new random chromosomes
        
    %% New Population
    Pop = [ElitPop ; CrossPop ; MutatPop];
    Cost = feval(CostFuncName,Pop);
    [Cost Indx] = sort(Cost);
     varcost=var(Cost);%calculates variance in cost
     z=0;
   for ii=1:100
       z=Cost(ii)+z;
   end
       mean1=z/100; %average for current iteration
       ma=max(Cost); %max cost for current iteration
       mi=min(Cost); %min cost for current iteration
       mean=1-((mean1-mi)/(ma-mi)); %mean fitness for current generation
     Pop = Pop(Indx,:);%again sort the new population according to the cost
    
      

    %% Algorithm Progress
   disp('----------------------------------------------')
    BestP = Pop(1,:) %display best population for current iteration
    BestC = Cost(1)  %display best cost for current iteration
    MinMat(Iter) = Cost(1);%creates a matrix of minimum cost of each iteration
    best=1-(BestC/ma); %best fitness for the current iteration
    w=evalfis([Iter;best;varcost;mean],fismat);% sends the values of the parameters to be evaluated by the fuzzy system
    MutatPercent = w(1);%returns mutation percent for next iteration
    CrossPercent = w(2);% returns crossover percent for next iteration
    PopSize= w(3);
   
    it=it+1;
    semilogy(Iter,MinMat(Iter),'r.')%plots iteration v/s min cost for the iteration
 hold on
end
%% Results
BestSolution = Pop(1,:)
BestCost = Cost(1,:)

%% End of Program
toc
