%%%Data Preprocessing Template

%%Importing the dataset
data = readtable('D:\Training\Everything MachineLearning\MATLAB\[FreeCourseSite.com] Udemy - MATLAB Master Class Go from Beginner to Expert in MATLAB\18. Segment 3.1 Data Preprocessing\Data Preprocessing\Data_6.csv')

%%Handling Missing Values
%Method 1: Deleting rows or column
complete_data = rmmissing(data,2);
data = complete_data;
%Method 1.1: Deleting rows or columns based on Relative Percentage of missing
restricted_missing = rmmissing(data,2,'MinNumMissing',3);
data = restricted_missing;
%Method 2: Using Mean
M_Age = mean(data.Age, 'omitnan');
U_Age = fillmissing(data.Age, 'constant',M_Age);
data.Age = U_Age;
%Dealing with missing non-numeric data
data.Opinion = categorical(data.Opinion);
Freq_opinion = mode(data.Opinion);
Opinion = fillmissing(data.Opinion,'constant',cellstr(Freq_opinion));
data.Opinion = Opinion;

%%Handling Ouliers
% Method 1: Deleting Rows
outlier = isoutlier(data.Age);
data = data(~outlier,:); 
% Method 2: Filling Outliers
Age = filloutliers(data.Age,'clip','mean')
data.Age = Age;

%%Categorical Data
data = categorical_data_to_dummy_variables(data,data.Location);
data.Location = [];
%Method 2: Categorical data (with order)
new_variable = categorical_data_to_numbers(data.YearlyIncome,{'Average', 'High', 'Very High', 'Low'}, [2 3 5 1]);
data.YearlyIncome = new_variable

%%Feature Scaling
%Method 1: Standardization
stand_age = (data.Age - mean(data.Age))/std(data.Age)
data.Age = stand_age; 
%Method 2: Normalization
normalize_age = (data.Age - min(data.Age)) / (max(data.Age) - min(data.Age))
data.Age = normalize_age;


%writetable(data,'D:\preprocessed_data.csv'); 
function new_variable = encoding_categorical_data(variable,values_set,numbers) 

[rows,col] = size(variable);


new_variable = zeros(rows,1);
 
for i=1:length(values_set)
    indices = ismember(variable,values_set{i});
    new_variable(indices) = numbers(i);
end 

end 

function data = categorical_data_to_dummy_variables(data,variable)

unique_values = unique(variable);
 
for i=1:length(unique_values)
    dummy_variable(:,i) = double(ismember(variable,unique_values{i})) ;
end 


T = table;
[rows, col] = size(dummy_variable);

for i=1:col
    T1 = table(dummy_variable(:,i));
    T1.Properties.VariableNames = unique_values(i);
    T = [T T1];
end 

    data = [T data]; 
 end 
