/**
 * General class containing main program to run the
 * iterated Prisoner's Dilemma (IPD).
 * @author	081028AW
 */
public class RunIPDTournament extends Object
   {
  /**
   * Main program to start IPD program.
   */

   public static void main(String args[])
      {
      int i, j, k;
      int maxSteps = 50;
      int numPlayers = 5;
      int temp;
      int sum[];
      int score[][];
      String tempname;

      Strategy player[];
      IteratedPD ipd;

      for (i=0; i<args.length; i++)
         {
        /* check parameters */
         if (args[i].equals("-l") || args[i].equals("-L"))
            {
            maxSteps = Integer.parseInt(args[i+1]);
            System.out.println(" Max steps = " + maxSteps);
            }  /* if */
         }  /* for i */

      player = new Strategy[numPlayers];
      sum = new int[numPlayers];
      score = new int[numPlayers][numPlayers];

     // initializing strategies
      player[0] = new StrategyAlwaysCooperate();
      player[1] = new StrategyTest();
      player[2] = new StrategyRandom();
      player[3] = new StrategyTitForTat();
      player[4] = new StrategyTitForTwoTats();

      System.out.printf(" Steps: %d \n", maxSteps);
      System.out.printf("                                    ");
      for (j=0; j<numPlayers; j++)
         System.out.printf(" %6d ", j);
      System.out.printf("    Sum\n");

      for (i=0; i<numPlayers; i++)
         {
         sum[i] = 0;
         System.out.printf(" %30s %3d ", player[i].name, i);
         for (j=0; j<numPlayers; j++)
            {
           // starting strategies
            player[0] = new StrategyTest2();
            player[1] = new StrategyTest();
            player[2] = new StrategyRandom();
            player[3] = new StrategyTitForTat();
            player[4] = new StrategyTitForTwoTats();

            ipd = new IteratedPD(player[i], player[j]);
            ipd.runSteps(maxSteps);
            System.out.printf(" %6d ", ipd.player1Score());
            sum[i] += ipd.player1Score();
            score[i][j] = ipd.player1Score();
/*
      System.out.printf(" Player 1 score = %d (%s)\n", ipd.player1Score(), player[i].name);
      System.out.printf(" Player 2 score = %d (%s)\n", ipd.player2Score(), player[j].name);
*/
            }
         System.out.printf(" %6d  %s\n", sum[i], player[i].name);
         }

      /* sort arrays */
      for (i=0; i<numPlayers; i++)
         {
         for (j=i; j<numPlayers; j++)
            {
            if (sum[j] > sum[i])
               {
               temp = sum[j];
               sum[j] = sum[i];
               sum[i] = temp;
               tempname = player[j].name;
               player[j].name = player[i].name;
               player[i].name = tempname;
               for (k=0; k<numPlayers; k++)
                  {
                  temp = score[j][k];
                  score[j][k] = score[i][k];
                  score[i][k] = temp;
                  }
               }
            }
         }

      System.out.printf("\n     SORTED:\n");
      for (i=0; i<numPlayers; i++)
         {
/*
         System.out.printf(" %30s %3d ", player[i].name, i);
         for (j=0; j<numPlayers; j++)
            {
            System.out.printf(" %6d ", score[i][j]);
            }
*/
         System.out.printf(" %6d  %s\n", sum[i], player[i].name);
         }


      }  /* main */
   }  /* class RunIPDTournament */

