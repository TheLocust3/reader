import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import styled from '@emotion/styled';

import Users from '../api/users';
import { colors } from '../constants';

const Container = styled.div`
  width: 100%;
  height: 100%;

  display: flex;
  align-items: center;
  justify-content: center;
  vertical-align: middle;
`

const LoginContainer = styled.div`
  width: 400px;
  height: 300px;

  padding-top: 20px;
  padding-bottom: 20px;
  padding-left: 30px;
  padding-right: 30px;

  border: 1px solid ${colors.black};
  border-radius: 10px;
`;

const Title = styled.div`
  padding-top: 5px;
  padding-bottom: 35px;

  font-size: 36px;
`;

const ErrorLabel = styled.div`
  height: 30px;

  font-size: 14px;
`;

const Label = styled.div`
  padding-bottom: 3px;
`;

const Spacer = styled.div`
  height: 15px;
`;

const Textbox = styled.input`
  display: block;
  box-sizing: border-box;

  width: 100%;
  height: 35px;

  padding-left: 10px;
  padding-right: 10px;

  border: 1px solid ${colors.lightBlack};
  border-radius: 5px;

  font-size: 15px;
  font-family: 'Roboto', sans-serif;
  font-weight: 100;
`;

const Submit = styled.button`
  width: 100%;
  height: 40px;

  cursor: pointer;

  border: 1px solid ${colors.lightBlack};
  border-radius: 10px;

  background-color: white;

  font-size: 18px;
  font-family: 'Roboto', sans-serif;
  font-weight: 100;

  &:hover {
    background-color: ${colors.whiteHover};
  }

  &:active {
    background-color: ${colors.whiteActive};
  }
`;

function Login() {
  const navigate = useNavigate();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const onSubmit = (event: any) => {
    event.preventDefault();
    Users.login(email, password)
      .then(() => navigate('/'))
      .catch(() => setError('Invalid email/password'));
  }

  return (
    <Container>
      <LoginContainer>
        <Title>Sign In</Title>

        <form onSubmit={onSubmit}>
          <Label>Email:</Label>
          <Textbox type="text" onChange={(event) => setEmail(event.target.value)} required />
          <Spacer />

          <Label>Password:</Label>
          <Textbox type="password" onChange={(event) => setPassword(event.target.value)} required />
          
          <ErrorLabel>{error}</ErrorLabel>

          <Submit>Submit</Submit>
          <input type="submit" style={{ display: "none" }} />
        </form>
      </LoginContainer>
    </Container>
  );
}

export default Login;
