import Head from "next/head";
import Grid1 from "../components/grid1";
import Grid2 from "../components/grid2";
export default function Home() {
  // Define the HouseNode class

  return (
    <div>
      <Head>
        <title>P2P Energy Sharing with Blockchain</title>
        <meta
          name="description"
          content="Description of P2P Energy Sharing with Blockchain"
        />
        <link rel="icon" href="/favicon.ico" />
      </Head>

      <main>
        <h1>P2P Energy Sharing with Blockchain</h1>
        <p>
          Welcome to our landing page for P2P Energy Sharing with Blockchain.
          Here, you will learn more about our platform and how we are
          revolutionizing the energy industry.
        </p>
        {/* Add more content as needed */}
      </main>
      <h2>ENERGY SHARING BETWEEN HOUSES WITH 5 STATES </h2>
      <h6>
        State1 : Demand Satisfied Plus | State2 : Demand Satisfied Minus |
        State3 : Surplus Energy | State4 : Energy Deficit | State5 : Grid
        Connection
      </h6>
      <Grid1 />
      <h2>
        ENERGY SHARING BETWEEN HOUSES WITH 3 STATES AND MODIFIED ALOGRITHM
      </h2>
      <h6>
        State1 : Energy Surplus | State2 : Energy Satisfied | State3 : Energy
        Deficit
      </h6>

      <Grid2 />
      <h2>
        ENERGY SHARING BETWEEN HOUSES WITH 5 STATES AND MODIFIED ALOGRITHM
      </h2>
      <h6>
        State1 : Demand Satisfied Plus | State2 : Demand Satisfied Minus |
        State3 : Surplus Energy | State4 : Energy Deficit | State5 : Grid
        Connection
      </h6>

      <Grid2 />
    </div>
  );
}
