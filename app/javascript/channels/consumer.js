import { createConsumer } from "@rails/actioncable";

window.App = window.App || {};
App.cable = createConsumer();

export default App.cable;