import { showcases } from "./showcases";

const Showcase = (() => {
  const init = () => {
    showcases.forEach((showcase) => showcase());
  };

  return { init };
})();

export default Showcase;
