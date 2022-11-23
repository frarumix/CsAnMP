function err = milne(errP,errC,valueP,valueC)
% MILNE Milne's local truncation error estimate.

err = norm(errC/(errP - errC)*(valueC - valueP));

end