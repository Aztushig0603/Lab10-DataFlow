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

    @Test
    @DisplayName("duPairs_03_empty_array_threshold_zero_present_true_best_false")
    void duPairs_03_empty_array_threshold_zero_present_true_best_false() {
        assertEquals(5, DataFlowTargets.bonus(new int[]{}, 0));
    }

    @Test
    @DisplayName("duPairs_04_all_absent_threshold_positive_present_false")
    void duPairs_04_all_absent_threshold_positive_present_false() {
        assertEquals(0, DataFlowTargets.bonus(new int[]{0, 0, 0}, 1));
    }

    @Test
    @DisplayName("duPairs_05_exact_present_threshold_and_short_streak")
    void duPairs_05_exact_present_threshold_and_short_streak() {
        assertEquals(5, DataFlowTargets.bonus(new int[]{1, 1, 0, 1, 1}, 4));
    }

    @Test
    @DisplayName("duPairs_06_streak_five_after_reset_kills_old_streak_definition")
    void duPairs_06_streak_five_after_reset_kills_old_streak_definition() {
        assertEquals(8, DataFlowTargets.bonus(new int[]{1, 0, 1, 1, 1, 1, 1}, 6));
    }

    @Test
    @DisplayName("duPairs_07_total_present_exceeds_best_streak_kills_wrong_best_update")
    void duPairs_07_total_present_exceeds_best_streak_kills_wrong_best_update() {
        assertEquals(5, DataFlowTargets.bonus(new int[]{1, 1, 0, 1, 1, 0, 1, 1, 1}, 7));
    }

    @Test
    @DisplayName("duPairs_08_best_streak_five_but_present_below_threshold_score_three")
    void duPairs_08_best_streak_five_but_present_below_threshold_score_three() {
        assertEquals(3, DataFlowTargets.bonus(new int[]{1, 1, 1, 1, 1}, 6));
    }

    @Test
    @DisplayName("duPairs_09_streak_comparison_false_after_shorter_streak")
    void duPairs_09_streak_comparison_false_after_shorter_streak() {
        assertEquals(5, DataFlowTargets.bonus(new int[]{1, 1, 0, 1}, 3));
    }

    @Test
    @DisplayName("duPairs_10_null_attendance_throws")
    void duPairs_10_null_attendance_throws() {
        assertThrows(IllegalArgumentException.class, () -> DataFlowTargets.bonus(null, 0));
    }

    @Test
    @DisplayName("duPairs_11_negative_threshold_throws")
    void duPairs_11_negative_threshold_throws() {
        assertThrows(IllegalArgumentException.class, () -> DataFlowTargets.bonus(new int[]{1}, -1));
    }
}
