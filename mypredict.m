function ypred = mypredict(tbl)
Mdl = loadCompactModel('subspacediscriminant');
label = predict(Mdl,X);
end