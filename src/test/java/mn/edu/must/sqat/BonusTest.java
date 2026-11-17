package mn.edu.must.sqat;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class BonusTest {
    // ALL-DEFS: minimum two executions. First reaches score=0 at return;
    // second reaches score=5, uses it in score += 3, then returns score=8.
    @Test
    @DisplayName("allDefs_01_reset_streak_and_score_zero_definition")
    void allDefs_01_reset_streak_and_score_zero_definition() {
        assertEquals(0, DataFlowTargets.bonus(new int[]{1, 0, 1}, 4));
    }

    @Test
    @DisplayName("allDefs_02_five_consecutive_days_score_five_then_eight")
    void allDefs_02_five_consecutive_days_score_five_then_eight() {
        assertEquals(8, DataFlowTargets.bonus(new int[]{1, 1, 1, 1, 1}, 5));
    }

}
