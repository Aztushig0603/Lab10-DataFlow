package mn.edu.must.sqat;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.assertEquals;

class GcdTest {
    @Test
    @DisplayName("gcd_7_0_x13_to_return20_y13_to_while_false15")
    void gcd_7_0_x13_to_return20_y13_to_while_false15() {
        assertEquals(7, DataFlowTargets.gcd(7, 0));
    }

    @Test
    @DisplayName("gcd_12_8_all_loop_du_pairs_including_second_iteration")
    void gcd_12_8_all_loop_du_pairs_including_second_iteration() {
        assertEquals(4, DataFlowTargets.gcd(12, 8));
    }
}
