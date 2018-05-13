function r = classification_rates(Xproj0, Xproj, class0, class1, alpha)

catst = (class0==0); dogst = (class0==1);
cats = (class1==0); dogs = (class1==1);

if all(Xproj0(catst)>=alpha)
    cat_rate = sum(Xproj(cats)>alpha) / sum(cats);
    dog_rate = sum(Xproj(dogs)<=alpha) / sum(dogs);
    total_rate = 0.5*(cat_rate + dog_rate);
else
    cat_rate = sum(Xproj(cats)<=alpha) / sum(cats);
    dog_rate = sum(Xproj(dogs)>alpha) / sum(dogs);
    total_rate = 0.5*(cat_rate + dog_rate);
end
r = [cat_rate, dog_rate, total_rate];

end