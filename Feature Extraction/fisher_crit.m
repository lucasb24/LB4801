function JW = fisher_crit(m1,m2,s1,s2)

JW = abs(m1 - m2)^2;
JW = JW/(s1+s2);

end