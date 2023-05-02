import Head from "next/head";
import Grid1 from "../components/grid1";

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
      <Grid1 />
    </div>
  );
}
