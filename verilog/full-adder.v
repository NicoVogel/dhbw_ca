include "half-adder.v"

module full_adder( output sum, carry_out,
                    input a, b, carry_in)
    wire partSum, carryFirst, carrySecond;
    xor(partSum, a, b);
    and(carryFirst, a, b);
    xor(sum, partSum, carry_in);
    and(carrySecond, partSum, carry_in);
    or(carry_out, carryFirst, carrySecond);
endmodule