function mmError = training_error(err,mm)
em = err.*mm; %error in mm
mmError = sqrt((em(1))^2 + (em(2))^2 + (em(3))^2);
end