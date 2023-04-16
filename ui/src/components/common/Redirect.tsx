import React from 'react';

interface Props {
  to: string;
}

function Redirect({ to }: Props) {
  console.log("TESTESTEST")
  window.location.href = to;
  return <div />;
}

export default Redirect;
