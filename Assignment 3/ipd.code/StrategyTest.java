/**
 * Class containing the random strategy.
 * @author	081028AW
 */
import java.util.ArrayList;
import java.util.Collections;

public class StrategyTest extends Strategy
   {
  /**
   * Encoding for a strategy.
   */
  // 0 = defect, 1 = cooperate
   ArrayList<Integer> opMoves = new ArrayList<Integer>();
   // opponentMove = Strategy.
   double coopProb = 0.65;
   int numDefects; 
   double alpha = 0.3;

  
   public StrategyTest()
      {
      name = "Test";
      }  /* StrategyRandom */

   public int nextMove()
      { 
      // Calculate probability change
      opMoves.add(opponentLastMove);
      numDefects = Collections.frequency(opMoves, 0);

      
      if (opMoves.isEmpty() == true)
         coopProb = coopProb - alpha * (coopProb/1) ;
      else
         coopProb = coopProb - alpha * (coopProb/numDefects);
      // Make move
      if (Math.random() < coopProb)  return 1;
      return 0;
      }  /* nextMove */
   }  /* class StrategyRandom */

